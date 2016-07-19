# Tapster on Heroku
## About
How to host Tapster demo app for PredictionIO (http://docs.prediction.io/demo/tapster/) on Heroku.

## Step 1: Create demo app
```
git clone https://github.com/chanlee514/Demo-Tapster && cd Demo-Tapster/
heroku create <your-demo-app-name>
bundle install
```

## Step 2: Deploy PredictionIO eventserver on Heroku
```
git clone https://github.com/chanlee514/pio-heroku && cd pio-heroku/
heroku create <your-eventserver-name> --buildpack=https://github.com/chanlee514/pio-heroku
heroku buildpacks:add heroku/scala
```
Request a help ticket on Heroku for slug size increase (https://help.heroku.com/tickets).
PredictionIO runs on Spark, and since Heroku currently doesn't have Spark support, 
we have to include it as part of our build. 
Commit and push to Heroku.
```
git push heroku master
```
Your eventserver will be ready at https://your-eventserver-name.herokuapp.com.

## Step 3: Create PredictionIO app
In your pio-heroku directory
```
heroku run createapp <your-pio-app-name>
```
This will output the accesskey for your PredictionIO app.
Modify PIO_EVENT_SERVER_URL, PIO_ACCESS_KEY in Demo-Tapster/.env
You can leave PIO_ENGINE_URL for now and change it after you have deployed your PredictionIO engine.
Commit and push Tapster app to Heroku.

## Step 4: Send event data to PredictionIO eventserver
In Demo-Tapster/ directory, run
```
heroku run rake db:migrate
heroku run rake import:episodes 
heroku run rake import:predictionio
```
This imports sample data to your app and sends sample user actions (some user likes some comic) to your eventserver.

## Step 5: Create PredictionIO engine
Download PredictionIO engine template (http://templates.prediction.io/) depending on your machine learning needs. 
Tapster uses Similar Product Template.
```
git clone https://github.com/chanlee514/pio-engine && cd pio-engine/
```

## Step 6: Build PredictionIO engine
In you engine directory, modify conf/pio-env.sh to match your eventserver's postgres database. 

Change PIO_STORAGE_SOURCES_PGSQL_USERNAME, PIO_STORAGE_SOURCES_PGSQL_PASSWORD to match the postgres username and password. These are automatically set by Heroku, and you can view them in the "Settings" tab in your Heroku dashboard.

Change PIO_STORAGE_SOURCES_PGSQL_URL to match Heroku's JDBC_DATABASE_URL. You can get this by running
```
heroku run bash 
echo $JDBC_DATABASE_URL
```

Then in your engine directory, run
```
heroku run build
```

## Step 7: Train PredictionIO engine
In your engine directory,
```
heroku run train
```

## Step 8: Deploy PredictionIO engine
In your engine directory,
```
heroku create <your-engine-name>
```
Commit and push your engine to Heroku.
```
git push heroku master
```

## Notes
Free Heroku dynos may not be suitable for running pio train. One alternative is to upgrade your plan. The other is to train locally, and then deploy to Heroku. To do the latter, remove "pio-autogen-manifest" token from the description field in manifest.json file after building the engine. Train using your local PredictionIO installation (with conf/pio-env.sh pointing to heroku eventserver) and continue to Step 8.


## For more information
View at: [tapster.prediction.io](http://tapster.prediction.io)

Built with: [PredictionIO](http://prediction.io)

Documentation: [PredictionIO/Tapster] (http://docs.prediction.io/demo/tapster/)
