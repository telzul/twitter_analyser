Twitter Analyser
================

## neo4j installieren:
    rake neo4j:install[community-2.1.5]
## Server starten
1. Neo4j starten
    rake neo4j:start
2. Server starten
    ./bin/rails server

## Vorübergehend um Tweets zu streamen
1. Neo4j starten
    rake neo4j:start
2. Rails Console öffnen
    ./bin/rails console
3. In Console:
    TwitterStream::Stream.stream("TOPIC")
4. Warten :)
5. Tweets, auf die geantwortet wurde nachladen. In Console:
    TwitterStream::Stream.FetchMissingTweets.perform

Achtung, nicht zu oft starten, Twitter schmeißt dich schnell raus mit TooManyRequests


## Wichtige TODOs:
* Visualisierungen einbauen
* Tweets verarbeiten als Sidekiq Job anlegen
* Tweets nachladen als Sidekiq Job?
* Daemon für Stream
* Sentimentanalyse auf Tweets machen → Sidekiq

