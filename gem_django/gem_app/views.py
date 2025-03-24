from django.shortcuts import render
import os
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from django.http import FileResponse, HttpResponseNotFound
import yaml
from .analyze_article_or_articles import analyze_article_or_articles
from .serializers import ArticleAnalysisRequestSerializer, ArticlesAnalysisRequestSerializer, DownloadFileSerializer

@api_view(['POST'])
def analyze_article_view(request):
    """
    View to analyze a single article using specified ChatGPT parameters.
    """
    try:
        serializer = ArticleAnalysisRequestSerializer(data=request.data)
        if serializer.is_valid():
            article_data = serializer.validated_data['article']
            parameters = serializer.validated_data['parameters']
            
            response_data = analyze_article_or_articles(article_data, parameters)

            return Response({'result': response_data}, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST']) 
def analyze_articles_view(request):
    """
    View to analyze multiple articles using specified ChatGPT parameters.
    """
    try:
        serializer = ArticlesAnalysisRequestSerializer(data=request.data)
        if serializer.is_valid():
            articles_data = serializer.validated_data['articles']
            parameters = serializer.validated_data['parameters']

            response_data = analyze_article_or_articles(articles_data, parameters)

            return Response({'result': response_data}, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])     
def download_csv_analysis_results_view(request):
    """
    View to download CSV analysis results.
    """
    try:
        serializer = DownloadFileSerializer(data=request.data)
        if serializer.is_valid():
            with open("gem_app/config/configs.yml", 'r') as config_file:
                config = yaml.load(config_file, Loader=yaml.FullLoader)

            file_name = serializer.validated_data['file_name']
            file_path = f"{config.get('path_output_csv_file')}{file_name}"
    
            if os.path.exists(file_path):
                response = FileResponse(open(file_path, 'rb'), status=status.HTTP_200_OK)
                response['Content-Disposition'] = f'attachment; filename={os.path.basename(file_path)}'
                response['Content-Type'] = 'text/csv; charset=utf-8'
                return response
            else:
                return HttpResponseNotFound('The requested file was not found.', status=status.HTTP_404_NOT_FOUND)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)