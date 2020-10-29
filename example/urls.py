from django.urls import path

from .views import ExampleView

app_name = 'example'
urlpatterns = [
    path('', ExampleView.as_view(), name='index'),
]
