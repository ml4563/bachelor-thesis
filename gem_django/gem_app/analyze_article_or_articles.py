import datetime
import os
import re
import unicodedata
import pandas as pd
import spacy
import yaml
from .llm.chat_gpt_request_handler import chat_gpt_request_handler

def analyze_article_or_articles(article_or_articles_data, chat_gpt_parameters):
    """
    Process one or more articles using specified ChatGPT parameters.
    """
    request_manager = chat_gpt_request_handler()

    # Load the spaCy French language model
    nlp = spacy.load("fr_core_news_sm")

    # Read the Configuration from YAML
    with open("gem_app/config/configs.yml", 'r') as config_file:
        config = yaml.load(config_file, Loader=yaml.FullLoader)

    # Building the data frame
    if isinstance(article_or_articles_data, list):
        # Multiple articles
        all_data = []
        for article in article_or_articles_data:
            data = {
                'no': article['no'],
                'semaine': article['semaine'],
                'média':article['media'],
                'article repris': article['articleRepris'],
                'url': article['url'],
                'article_title': article['title'],
                'article_desc': article['chapo'],
                'article_content': article['content'],
            }
            all_data.append(data)
        df = pd.DataFrame(all_data)
    else:
        # Single article
        data = {
                'no': [article_or_articles_data['no']],
                'semaine': [article_or_articles_data['semaine']],
                'média':[article_or_articles_data['media']],
                'article repris': [article_or_articles_data['articleRepris']],
                'url': [article_or_articles_data['url']],
                'article_title': [article_or_articles_data['title']],
                'article_desc': [article_or_articles_data['chapo']],
                'article_content': [article_or_articles_data['content']],
            }
        df = pd.DataFrame(data)

    print(df)
    
    # Load Corpora from Files
    corpus_files = config.get("dictionaries_files", [])
    corpora = {}
    for corpus_file in corpus_files:
        with open(corpus_file, 'r', encoding='utf-8-sig') as file:
            corpus_name = corpus_file.replace(".txt", "")
            corpus = [line.strip() for line in file]
            corpora[corpus_name] = corpus

    # Define custom lemmatization rules
    custom_rules = {
        "garde à vue": "garde_à_vue",
        "coup de tête": "coup_de_tête",
        "s'emporter": "s_emporter",
        "maladie mentale": "maladie_mentale",
        "pétage de câble": "pétage_de_câble",
        "soirée arrosée": "soirée_arrosée",
        "victime présumée": "victime_présumée",
        "relation toxique": "relation_toxique", 
        "voie de fait": "voie_de_fait",
        "violences domestiques": "violences_domestiques",
        "violences conjugales": "violences_conjugales",
        "ats": "ats"
    }

    # define the function for news aericle lemmatization
    def lemmatize(text):
        # Apply custom lemmatization rules
        for key, value in custom_rules.items():
            text = text.replace(key, value)
        doc = nlp(text)
        lemmas = [token.lemma_ for token in doc if not token.is_punct and not token.is_space]
        return lemmas
    
    # Define the function for corpus lemmatization WITH considering the term with multiple words
    def lemmatize_corpus(corpus):
        lemmatized_corpus = []

        for word in corpus:
            doc = nlp(word)
            lemmas = [token.lemma_ for token in doc]
            lemmatized_form = ' '.join(lemmas)
            lemmatized_corpus.append(lemmatized_form)
        
        return lemmatized_corpus
    
    # Search and Count using lemmatize function, should add lemmas to corpus as well
    def count_corpus_occurrences(text, corpus):
        article_lemmas = lemmatize(text)
        corpus_lemmas = lemmatize_corpus(corpus)
        matching_lemmas = [lemma for lemma in article_lemmas if lemma in corpus_lemmas]
        print("matching_lemmas")
        print(matching_lemmas)
        count = len(matching_lemmas)
        return count
    
    # Function for calculating the size of article
    def character_count(text):
        char_count = len(text)
        return char_count

    def classify_conditional_verbs(text):
        # Process the text
        doc = nlp(text)
        # Initialize counters
        total_verbs = 0
        conditional_verbs = 0
        # Iterate through tokens and count conditional verbs
        for token in doc:
            if token.pos_ == 'VERB':
                total_verbs += 1
                # Check if the verb ends with any of the conditional endings
                if any(token.text.endswith(ending) for ending in corpora.get("gem_app/dictionaries/verb_conditional", [])):
                    conditional_verbs += 1
                    print("conditional_verbs:")
                    print(token)
        
        # Calculate the proportion of conditional verbs
        print("Nb of conditional_verbs:", conditional_verbs)
        print("Nb of total_verbs:",total_verbs)

        if conditional_verbs > 0:
            proportion = conditional_verbs / total_verbs
        else:
            proportion = 0.0

        # Classify based on the proportion
        if proportion == 0:
            return 1  # Display 1 when proportion is 0
        elif proportion <= 0.25:
            return 0  # Display 0 when proportion is less than or equal to 0.25
        else:
            return -1  # Display -1 when proportion is greater than 0.25

    # Define a function to use ChatGPT to classify categories
    def classify_categories_with_chatGPT(chat_gpt_parameters, text):
        return request_manager.make_request(chat_gpt_parameters, text)
    
    # Extract the option numbers along with their corresponding text from ChatGPT results
    def extract_chatGPT_results(gpt_results):
        # Regular expression pattern to match question and option pairs
        pattern = r"Question\s+(\d+)\s*[:-]\s*Option\s+(\-?\d+)[\).\)]\s*(.+)"

        # Find all matches in the input text
        matches = re.finditer(pattern, gpt_results, re.IGNORECASE)

         # Initialize a list to store the extracted information
        extracted_info = []

        # Iterate through the matches and store them in the list
        for match in matches:
            # Extract the number, option, and text for each match
            question_number = int(match.group(1))
            option_number = int(match.group(2))
            explication = match.group(3)

            # Append the extracted information as a dictionary to the list
            extracted_info.append({
                "question_number": question_number,
                "option_number": option_number,
                "explication": explication.strip()
            })
        return extracted_info
        
    def safe_lower(text):
        return text.lower() if isinstance(text, str) else ''
    
    # Initialize empty list to store results
    big_article = 0;
    agence_results = []
    en_lien_avec_affaire_results = []
    mention_feminicide_results = []
    vocabulaire_results = []
    sante_mentale_results = []
    substance_psychotrope_results = []
    animalisant_results = []
    sideration_results = []
    culture_du_viol_results = []
    validite_results = []
    taille_results = []
    
    # openai API
    classification_results = []
    type_violence_results = []
    type_violence_explications = []
    feminicide_results = []
    feminicide_explications = []
    sources_results = []
    sources_explications = []
    hierarchisation_results = []
    hierarchisation_explications = []
    desc_victime_results = []
    desc_victime_explications = []
    desc_agresseur_results = []
    desc_agresseur_explications = []
    nationalite_results = []
    nationalite_explications = []
    desc_relation_protagonistes_results = []
    desc_relation_protagonistes_explications = []
    soustendent_violences_results = []
    soustendent_violences_explications = []
    escalade_violences_results = []
    escalade_violences_explications = []
    statistiques_results = []
    statistiques_explications = []
    autres_violences_results = []
    autres_violences_explications = []
    citations_results = []
    citations_explications = []
    ressources_results = []
    ressources_explications = []
    
    for index, row in df.iterrows():        
        article_body = (safe_lower(row["article_title"]) + 
                    safe_lower(row["article_desc"]) + 
                    safe_lower(row["article_content"]))
    
        article_count_words = len(article_body.split())
        print("article_count_words: " + str(article_count_words))
   
  
        # Article provient d'une agence
        agence = count_corpus_occurrences(article_body, [word.lower() for word in corpora.get("gem_app/dictionaries/agence", [])])
        if agence > 0:
            agence_results.append(1)
        else:
            agence_results.append(2) 

        # En lien avec une affaire
        lien = count_corpus_occurrences(article_body, [word.lower() for word in corpora.get("gem_app/dictionaries/en lien avec une affaire", [])])
        if lien > 0:
            en_lien_avec_affaire_results.append(1)
        else:
            en_lien_avec_affaire_results.append(2)
        
        # Féminicide / mention féminicide
        mention_feminicide = count_corpus_occurrences(article_body, [word.lower() for word in corpora.get("gem_app/dictionaries/mention_feminicide", [])])
        if mention_feminicide > 0:
            mention_feminicide_results.append(1)
        else:
            mention_feminicide_results.append(2)

        # Le vocabulaire 
        vocs_violence = count_corpus_occurrences(article_body, [word.lower() for word in corpora.get("gem_app/dictionaries/vocabulaire_violence", [])])
        vocs_minimisant = count_corpus_occurrences(article_body, [word.lower() for word in corpora.get("gem_app/dictionaries/vocabulaire_minimisant", [])])
        print("Nb vocs_violence: ", vocs_violence)
        print("Nb vocs_minimisant: ", vocs_minimisant)
        
        if vocs_violence > 0 and vocs_minimisant == 0:
            vocabulaire_results.append(1)
        elif vocs_violence == 0 and vocs_minimisant > 0:
            vocabulaire_results.append(-1)
        else:
            vocabulaire_results.append(0)
        
        # Mention de la santé mentale de l’auteur (ex. malade, pervers)
        sante_mentale = count_corpus_occurrences(article_body, [word.lower() for word in corpora.get("gem_app/dictionaries/sante mentale", [])])
        if sante_mentale > 0:
            sante_mentale_results.append(1)
        else:
            sante_mentale_results.append(2)

        # Mention des substances psychotropes
        substance_psychotrope = count_corpus_occurrences(article_body, [word.lower() for word in corpora.get("gem_app/dictionaries/substance psychotrope", [])])
        if substance_psychotrope > 0:
            substance_psychotrope_results.append(1)
        else:
            substance_psychotrope_results.append(2)

        # Mention d'une forme d’animalisation 
        animalisant = count_corpus_occurrences(article_body, [word.lower() for word in corpora.get("gem_app/dictionaries/animalisant", [])])
        if animalisant > 0:
            animalisant_results.append(1)
        else:
            animalisant_results.append(2)

        # Mention du processus de sidération 
        sideration = count_corpus_occurrences(article_body, [word.lower() for word in corpora.get("gem_app/dictionaries/sideration", [])])
        if sideration > 0:
            sideration_results.append(1)
        else:
            sideration_results.append(2)

        # Mention de la culture du viol / objetisation /sexisme 
        culture_du_viol = count_corpus_occurrences(article_body, [word.lower() for word in corpora.get("gem_app/dictionaries/culture du viol", [])])
        if culture_du_viol > 0:
            culture_du_viol_results.append(1)
        else:
            culture_du_viol_results.append(2)

        # La validité des informations 
        validite = classify_conditional_verbs(article_body)
        if validite == 1:
            validite_results.append(1)
        elif validite == 0:
            validite_results.append(0)
        else:
            validite_results.append(-1)
    
        # La taille d'article
        char_count = character_count(article_body)
        if char_count <= 1000:
            taille_results.append(1)
        elif char_count <= 4000:
            taille_results.append(2)
        else:
            taille_results.append(3)

        if article_count_words < chat_gpt_parameters["thresholdWord"]:
            # stop to generate the results from ChatGPT
            
            # Iterate through the DataFrame and use ChatGPT to classify categories
            result = classify_categories_with_chatGPT(
                chat_gpt_parameters,
                article_body,
            )
    
            classification_results.append(result)

            # extract the results
            options = extract_chatGPT_results(result)

            type_violence_re = ""
            type_violence_ex = ""
            feminicide_re = ""
            feminicide_ex = ""
            sources_re = ""
            sources_ex = ""        
            hierarchisation_re = ""
            hierarchisation_ex = ""
            desc_victime_re = ""
            desc_victime_ex = ""   
            desc_agresseur_re = ""
            desc_agresseur_ex = ""
            nationalite_re = ""
            nationalite_ex = ""
            desc_relation_protagonistes_re = ""
            desc_relation_protagonistes_ex = ""
            soustendent_violences_re = ""
            soustendent_violences_ex = ""
            escalade_violences_re = ""
            escalade_violences_ex = ""
            statistiques_re = ""
            statistiques_ex = ""
            autres_violences_re = ""
            autres_violences_ex = ""
            citations_re = ""
            citations_ex = ""
            ressources_re = ""   
            ressources_ex = ""

            for option_info in options:
                if option_info["question_number"] == 1:
                    type_violence_re = option_info["option_number"]
                    type_violence_ex = option_info["explication"]
                elif option_info["question_number"] == 2:
                    feminicide_re = option_info["option_number"]
                    feminicide_ex = option_info["explication"]
                elif option_info["question_number"] == 3:
                    sources_re = option_info["option_number"]
                    sources_ex = option_info["explication"]   
                elif option_info["question_number"] == 4:
                    hierarchisation_re = option_info["option_number"]
                    hierarchisation_ex = option_info["explication"]
                elif option_info["question_number"] == 5:
                    desc_victime_re = option_info["option_number"]
                    desc_victime_ex = option_info["explication"]
                elif option_info["question_number"] == 6:
                    desc_agresseur_re = option_info["option_number"]
                    desc_agresseur_ex = option_info["explication"]
                elif option_info["question_number"] == 7:
                    nationalite_re = option_info["option_number"]
                    nationalite_ex = option_info["explication"]
                elif option_info["question_number"] == 8:
                    desc_relation_protagonistes_re = option_info["option_number"]
                    desc_relation_protagonistes_ex = option_info["explication"]
                elif option_info["question_number"] == 9:
                    soustendent_violences_re = option_info["option_number"]
                    soustendent_violences_ex = option_info["explication"]
                elif option_info["question_number"] == 10:
                    escalade_violences_re = option_info["option_number"]
                    escalade_violences_ex = option_info["explication"]
                elif option_info["question_number"] == 11:
                    statistiques_re = option_info["option_number"]
                    statistiques_ex = option_info["explication"]
                elif option_info["question_number"] == 12:
                    autres_violences_re = option_info["option_number"]
                    autres_violences_ex = option_info["explication"]
                elif option_info["question_number"] == 13:
                    citations_re = option_info["option_number"]
                    citations_ex = option_info["explication"]
                elif option_info["question_number"] == 14:
                    ressources_re = option_info["option_number"]
                    ressources_ex = option_info["explication"]
                
                print("Question Number:", option_info["question_number"])
                print("Option Number:", option_info["option_number"])
                print("Explication:", option_info["explication"])
                print()  # Add a separator between matches

            type_violence_results.append(type_violence_re if type_violence_re != "" and type_violence_re is not None else "-")
            type_violence_explications.append(type_violence_ex if type_violence_ex != "" and type_violence_ex is not None else "-")
            
            feminicide_results.append(feminicide_re if feminicide_re != "" and feminicide_re is not None else "-")
            feminicide_explications.append(feminicide_ex if feminicide_ex != "" and feminicide_ex is not None else "-")
            
            sources_results.append(sources_re if sources_re != "" and sources_re is not None else "-")
            sources_explications.append(sources_ex if sources_ex != "" and sources_ex is not None else "-")
            
            hierarchisation_results.append(hierarchisation_re if hierarchisation_re != "" and hierarchisation_re is not None else "-")
            hierarchisation_explications.append(hierarchisation_ex if hierarchisation_ex != "" and hierarchisation_ex is not None else "-")
            
            desc_victime_results.append(desc_victime_re if desc_victime_re != "" and desc_victime_re is not None else "-")
            desc_victime_explications.append(desc_victime_ex if desc_victime_ex != "" and desc_victime_ex is not None else "-")
            
            desc_agresseur_results.append(desc_agresseur_re if desc_agresseur_re != "" and desc_agresseur_re is not None else "-")
            desc_agresseur_explications.append(desc_agresseur_ex if desc_agresseur_ex != "" and desc_agresseur_ex is not None else "-")
            
            nationalite_results.append(nationalite_re if nationalite_re != "" and nationalite_re is not None else "-")
            nationalite_explications.append(nationalite_ex if nationalite_ex != "" and nationalite_ex is not None else "-")
            
            desc_relation_protagonistes_results.append(desc_relation_protagonistes_re if desc_relation_protagonistes_re != "" and desc_relation_protagonistes_re is not None else "-")
            desc_relation_protagonistes_explications.append(desc_relation_protagonistes_ex if desc_relation_protagonistes_ex != "" and desc_relation_protagonistes_ex is not None else "-")
            
            soustendent_violences_results.append(soustendent_violences_re if soustendent_violences_re != "" and soustendent_violences_re is not None else "-")
            soustendent_violences_explications.append(soustendent_violences_ex if soustendent_violences_ex != "" and soustendent_violences_ex is not None else "-")
            
            escalade_violences_results.append(escalade_violences_re if escalade_violences_re != "" and escalade_violences_re is not None else "-")
            escalade_violences_explications.append(escalade_violences_ex if escalade_violences_ex != "" and escalade_violences_ex is not None else "-")
            
            statistiques_results.append(statistiques_re if statistiques_re != "" and statistiques_re is not None else "-")
            statistiques_explications.append(statistiques_ex if statistiques_ex != "" and statistiques_ex is not None else "-")
            
            autres_violences_results.append(autres_violences_re if autres_violences_re != "" and autres_violences_re is not None else "-")
            autres_violences_explications.append(autres_violences_ex if autres_violences_ex != "" and autres_violences_ex is not None else "-")
            
            citations_results.append(citations_re if citations_re != "" and citations_re is not None else "-")
            citations_explications.append(citations_ex if citations_ex != "" and citations_ex is not None else "-")
            
            ressources_results.append(ressources_re if ressources_re != "" and ressources_re is not None else "-")
            ressources_explications.append(ressources_ex if ressources_ex != "" and ressources_ex is not None else "-")

            # """
            print ("Article " + str(index+1) + " has been analyzed and saved!")
        else:
            # openai API
            classification_results.append("-")
            type_violence_results.append("-")
            type_violence_explications.append("-")
            feminicide_results.append("-")
            feminicide_explications.append("-")
            sources_results.append("-")
            sources_explications.append("-")
            hierarchisation_results.append("-")
            hierarchisation_explications.append("-")
            desc_victime_results.append("-")
            desc_victime_explications.append("-")
            desc_agresseur_results.append("-")
            desc_agresseur_explications.append("-")
            nationalite_results.append("-")
            nationalite_explications.append("-")
            desc_relation_protagonistes_results.append("-")
            desc_relation_protagonistes_explications.append("-")
            soustendent_violences_results.append("-")
            soustendent_violences_explications.append("-")
            escalade_violences_results.append("-")
            escalade_violences_explications.append("-")
            statistiques_results.append("-")
            statistiques_explications.append("-")
            autres_violences_results.append("-")
            autres_violences_explications.append("-")
            citations_results.append("-")
            citations_explications.append("-")
            ressources_results.append("-")
            ressources_explications.append("-")
            
            print ("Article " + str(index+1) + " has NOT been analyzed with ChatGPT!")
            big_article = big_article + 1

    df["Article provient d'une agence"] = agence_results
    df["Article en lien direct avec une affaire"] = en_lien_avec_affaire_results
    df["Taille de l'article"] = taille_results
    df["Type de violence traitées"] = type_violence_results
    df["Féminicide"] = feminicide_results
    df["Le vocabulaire"] = vocabulaire_results
    df["Mention féminicide"] = mention_feminicide_results
    df["Les sources"] = sources_results
    df["La validité des informations"] = validite_results
    df["Hiérarchisation de l'information"] = hierarchisation_results
    df["La description de la victime"] = desc_victime_results
    df["La description de l'agresseur"] = desc_agresseur_results
    df["La nationalité est mentionnée"] = nationalite_results
    df["La santé mentale est mentionnée"] = sante_mentale_results
    df["Le rapport à des substances psychotropes est mentionné"] = substance_psychotrope_results
    df["Une forme d'animalisation est présente"] = animalisant_results
    df["La description de la relation entre les protagonistes"] = desc_relation_protagonistes_results
    df["Les mécanismes qui sous-tendent les violences"] = soustendent_violences_results
    df["L'escalade/continuum  des violences est mentionnée"] = escalade_violences_results
    df["Le processus de sidération est mentionnée"] = sideration_results
    df["La culture du viol / objetisation /sexisme sont mentionnée"] = culture_du_viol_results
    df["Les statistiques"] = statistiques_results
    df["La mention d'autres violences"] = autres_violences_results
    df["Citations"] = citations_results
    df["Ressources proposées"] = ressources_results

    # Add the classification results to the DataFrame
    df["classification_result"] = classification_results
    df["Explication - type de violence traitées"] = type_violence_explications
    df["Explication - Féminicide"] = feminicide_explications
    df["Explication - Les sources"] = sources_explications
    df["Explication - hiérarchisation de l'information"] = hierarchisation_explications
    df["Explication - la description de la victime"] = desc_victime_explications
    df["Explication - la description de l'agresseur"] = desc_agresseur_explications
    df["Explication - la nationalité est mentionnée"] = nationalite_explications
    df["Explication - la description de la relation entre les protagonistes"] = desc_relation_protagonistes_explications
    df["Explication - les mécanismes qui sous-tendent les violences"] = soustendent_violences_explications
    df["Explication - l'escalade /continuum  des violences est mentionnée"] = escalade_violences_explications
    df["Explication - les statistiques"] = statistiques_explications
    df["Explication - la mention d'autres violences"] = autres_violences_explications
    df["Explication - citations"] = citations_explications
    df["Explication - ressources proposées"] = ressources_explications

    # print("********** len(df) **********")
    # print(len(df))
    
    # Date and time of day
    datetime_string = datetime.datetime.now().strftime("%d%m%Y_%H%M%S")

    if len(df) == 1:
        # File name generation for one article
        # Extract the article title
        article_title = df["article_title"].iloc[0]
        # Extract the first three words of the article title
        first_three_words = ' '.join(article_title.split()[:3])
        # Remove accents and normalize the string
        nfkd_form = unicodedata.normalize('NFKD', first_three_words)
        # Keep only ASCII characters
        only_ascii = nfkd_form.encode('ASCII', 'ignore').decode('ASCII')
        # Remove non-alphanumeric characters
        normalized_title  = re.sub(r'\W+', '', only_ascii)
        # CSV file name
        output_csv_file_name = f"{normalized_title}_{datetime_string}.csv"
    else:
        # File name generation for several articles
        # CSV file name
        output_csv_file_name = f"output_{datetime_string}.csv"
   
    # Path of the csv directory
    path_output_csv_file = config.get("path_output_csv_file")
    # Full path to the output CSV file
    output_csv = f"{path_output_csv_file}{output_csv_file_name}"

    # Initialize lists for ChatGPT parameters
    chat_gpt_param_keys = list(chat_gpt_parameters.keys())
    chat_gpt_param_values = list(chat_gpt_parameters.values())

    # Add ChatGPT parameters to the DataFrame
    for param_key, param_value in zip(chat_gpt_param_keys, chat_gpt_param_values):
        df[f"ChatGPT Param - {param_key}"] = param_value
        
    # Save the results DataFrame to CSV
    if not os.path.isfile(output_csv):
        df.to_csv(output_csv, index=False, header=True, encoding='utf-8-sig', lineterminator='\r\n')
    else:
        df.to_csv(output_csv, index=False, header=False, mode='a', encoding='utf-8-sig', lineterminator='\r\n')

    print("All artilces analyzed and results saved.")
    print(str(big_article) + " articles have not been handled by ChatGPT.")

    return output_csv_file_name