import logging
from time import sleep

from django.http import HttpResponse, HttpRequest
from django.views import View

import newrelic.agent

logger = logging.getLogger(__name__)


class ExampleView(View):
    def get(self, request: HttpRequest):
        sleep_time = int(request.GET.get("sleep", 0))
        if sleep_time < 0:
            sleep_time = 0
        elif sleep_time > 10:
            sleep_time = 10
        sleep(sleep_time)
        return HttpResponse(f"Slept for {sleep_time} seconds.")
