"""
harakiri-new-relic URL Configuration
"""
from django.urls import path, include

urlpatterns = [
    path('', include('example.urls')),
]
