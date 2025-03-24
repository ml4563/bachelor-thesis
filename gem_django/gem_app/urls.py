from django.urls import path
from .views import analyze_article_view, analyze_articles_view, download_csv_analysis_results_view

urlpatterns = [
    path('gem_app/api/analyzearticle/', analyze_article_view, name='analyse_single'),
    path('gem_app/api/analyzearticles/', analyze_articles_view, name='analyse_multi'),
    path('gem_app/api/downloadcsvanalysisresults/', download_csv_analysis_results_view, name='download_csv_analysis_results'),
]
