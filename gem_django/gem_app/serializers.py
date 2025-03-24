from rest_framework import serializers

class ArticleSerializer(serializers.Serializer):
    """ 
    Serializer to represent an article
    """
    no = serializers.IntegerField()
    semaine = serializers.IntegerField()
    media = serializers.IntegerField()
    articleRepris = serializers.IntegerField()
    url = serializers.URLField()
    title = serializers.CharField()
    chapo = serializers.CharField()
    content = serializers.CharField()

class ChatGptParametersSerializer(serializers.Serializer):
    """ 
    Serializer to represent chatGPT parameters required for analysis
    """
    prompt = serializers.CharField()
    model = serializers.CharField()
    content = serializers.CharField()
    topP = serializers.FloatField()
    frequencyPenalty = serializers.FloatField()
    presencePenalty = serializers.FloatField()
    thresholdWord = serializers.IntegerField()
    maxTokens = serializers.IntegerField()
    temperature = serializers.FloatField()

class ArticleAnalysisRequestSerializer(serializers.Serializer):
    """
    Serializer to represent an analysis request for a single  article.
    """
    article = ArticleSerializer()
    parameters = ChatGptParametersSerializer()

class ArticlesAnalysisRequestSerializer(serializers.Serializer):
    """
    Serializer to represent an analysis request for several articles.
    """
    articles = serializers.ListField(child=ArticleSerializer())
    parameters = ChatGptParametersSerializer()

class DownloadFileSerializer(serializers.Serializer):
    """ 
    Serializer to represent the file to be downloaded
    """
    file_name = serializers.CharField()