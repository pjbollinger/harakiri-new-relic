# Harakiri New Relic Tests

In our system, we are not able to retrieve uWSGI harakiris inside of New Relic.
This is likely due to the web workers killing themselves off, which would prevent the Python agent from sending in the report.
Ideally, I'd like to see a way to capture the reports that were started and finish them with an error that they timed out.
Worst-case, I'd like to see a transaction error that has no info other than the response was 500 and it took the `harakiri timeout limit` to complete.

## How to run

1. Clone/Download Repository
2. Build/Run the Docker container with the proper New Relic license key: ` docker build -t harakiri-new-relic . && docker run --rm -p 8000:8000 --env NEW_RELIC_LICENSE_KEY=SECRET --name harakiri-new-relic harakiri-new-relic`
3. Run `./simulate-load-without-timeouts.sh` to see data populate in New Relic with requests of durations 0, 1, 2, 3, and 4 seconds
4. Stop previous script. 
5. Run `./simulate-load-with-timeouts.sh` and note that data is no longer being sent to New Relic due to the uWSGI worker restarting

## Expected behavior

When running `./simulate-load-with-timeouts.sh`, I expect all the requests to populate inside of New Relic.
The ones that were successful should show as normal.
The ones that timed out due to harakiri should report as the duration of the harakiri (5 seconds in this case) and those same requests should report as an error of status 500.

## Extra notes

Run only the Django server:
```
python manage.py runserver 0.0.0.0:8000
```

Run the Django server with uWSGI:
```
uwsgi --module=config.wsgi:application --env DJANGO_SETTINGS_MODULE=config.settings --http=0.0.0.0:8000 --harakiri=5 --harakiri-verbose --master
```

Run the Django server with uWSGI and the `newrelic-admin` tool:
```
newrelic-admin run-program uwsgi --module=config.wsgi:application --env DJANGO_SETTINGS_MODULE=config.settings --http=0.0.0.0:8000 --harakiri=5 --harakiri-verbose --master --enable-threads --single-interpreter
```