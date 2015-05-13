# Dokumentation TwitterProjekt
## Ursprüngliche Ziele
Kommunikation bei Twitter basiert auf 140 Zeichen langen Nachrichten von einem Sender zu beliebig vielen Empfängern. Zum Einen sind dies _Follower_, also Nutzer, die explizit Nachrichten des Senders erhalten wollen. Zum Anderen Beobachter bestimmter Themen (ursprünglich mit Hilfe von sogenannten _Hashtags_, Wörter mit vorangestelltem #).
Nutzer machten sich die Hashtags schnell zu Nutze und Diskussionen um ein Thema konnten mit Hilfe des Hashtags gesammelt werden. Direkter noch ist eine Antwort auf einen Tweet, wenn der Nutzername auf dessen Tweet sich bezogen wird in die Antwort eingebunden wird. TODO Beispiel
So können Diskussionen geführt werden, der Dienstanbieter selbst ermöglicht mittlerweile eine Ansicht, die es ermöglicht einen Gesprächsverlauf nachzuvollziehen, allerdings in recht begrenztem Umfang. Es ist dort nicht immer ganz klar welcher Tweet eine Antwort auf welchen ist und wieviele _Unterdiskussionen_ es gibt. Die Twitter-API enthält Informationen darüber, ob ein Tweet eine Antwort auf einen Anderen ist und wenn ja, welchen.
Ein Ziel dieses Projektes war die Ansicht des Diskussionsverlaufes Graphischer darzustellen. Gespräche sollten sich als Baumstrukturen aufbauen, sodass nachvollziehbarer ist, wer wann wem antwortet und wie es eventuell unterteilt ist.

Ein weiteres Ziel war die Inhaltliche Analyse der Tweets, mittels Sentimentanalyse sollten den einzelnen Tweets eine _Stimmung_ zugeordnet werden, ob diese zum Thema positiv, Negativ, oder Neutral gegenüber stehen. So war die Überlegung, dass bei einem Gesprächsverlauf eine generelle Verlagerung der Stimmung erkennbar sein könnte. Beispielsweise direkt in einem Twittergespräch oder Unterhaltungen parallel zu Fernsehübertragungen wie etwa Fußballspiele oder Ausstrahlung eines _Tatort_.


## Aufgekommene Probleme
### Twitter-API
Die Twitter-API bietet theoretisch viele Möglichkeiten auf Tweets zuzugreifen, insbesondere sticht hier die Suchfunktion heraus, sie ermöglicht die Suche auf aktuellen und beliebten Tweets. Jedoch ist sie nicht vollständig, nach eigenen Angaben werden nicht alle passenden Tweets und User zurückgegeben. Es wird stattdessen auf die _Streaming-API_ verwiesen, welche wir daher auch benutzten. Sie ist dreigeteilt, es gibt _User-Streams_, die in etwa die Sicht eines einzelnen Benutzers wiederspiegeln, _Site-Streams_, die dazu dienen anderen Applikationen Zugriff im Auftrag mehrerer Nutzer zu gewähren, und drittens _Public-Streams_ mit denen Nutzer oder Themen verfolgt werden können. Letztere wird auch explizit für Data-Mining-Verfahren empfohlen. Diese Public-Streams-API ermöglicht das Verfolgen von Tweets in Echtzeit, als Parameter kann man User-IDs, geographische Angaben oder bis zu 400 Keywords angeben. Für den Mechanismus wird HTTP POST verwendet und dabei die Sitzung offen gehalten, sodass Daten von Twitter an die verbundene Applikation ohne weitere Requests gesendet werden.

Da ein Webservice implementiert werden sollte, hatten wir zum Ziel dass in einem Formular neue Themen hinzugefügt werden können und Ergebnisse dazu zeitnah visualisiert. Da jedoch für neue Keywords die Verbindung neu aufgebaut werden muss, stieß das Vorgehen schnell an Rate-Limits. Twitter [3] gibt in der Dokumentation zwar an es gäbe für Entwickler kleine Spielräume, in denen auch mehrere Dutzend Anfragen in kurzer Zeit kein Problem wären, jedoch stellte sich beim Testen heraus, dass bereits wenige Verbindungen zu längeren Wartezeiten führen. Bereits bei fünf Verbindungen innerhalb weniger Minuten wurden die Limits erreicht, Twitter selbst gibt die genauen Strategien nicht öffentlich preis.

### Gem __tweetstream__
Aus dem vergangenen Abschnitt ist ersichtlich, dass ein spontanes Verändern der Keywords nicht ohne weiteres möglich ist. Um dies zu umgehen wurden verschiedene Möglichkeiten ausprobiert Veränderte Anfragen zu sammeln und seltener neue Verbindungen aufzubauen.
Da das Projekt auf Basis von Ruby on Rails entwickelt wird, wurde für die Verbindung zu Twitter ein existierendes _gem_ verwendet: __tweetstream__[4]. Um parallel zu der Weboberfläche im Hintergrund Dienste ablaufen zu lassen, insbesondere die Daten von Twitter zu empfangen, wurde das Gem mit der integrierten Daemonfunktion alleinstehend gestartet. Um die Rate-Limits abzufangen implementiert das Gem die von Twitter vorgeschlagenen Strategien, leider half dies dennoch nicht. Das Starten als Daemon erschwerte zudem das aktualisieren der Topics, der theoretisch mögliche Mechanismus schlägt beim Versuch erneut zu verbinden Fehl (auch ohne die Rate-Limits ausgereizt zu haben).

### Daten
Die dennoch gesammelten Daten offenbarten ein weiteres Problem, über die Streaming-API werden nur Tweets ausgegeben, die die angegebenen Suchterme enthalten. Es ist also nicht möglich eine Konversation darüber zu verfolgen, wenn nicht gleichzeitig alle Teilnehmer das Thema, etwa in einem Hashtag, in jedem Tweet verwenden. Theoretisch enthalten die Daten die Information, ob ein Tweet eine Antwort auf einen anderen enthalten ist, es ist jedoch nicht möglich alle Antworten auf einen Tweet anzufragen.
Als Ergebnis bleibt schließlich eine flache Struktur von einzeln stehenden Tweets übrig, nur vereinzelt mit Bezugsinformation, Visualisierungen sind kaum sinnvoll.
Als Herausforderung blieb die Sentimentanalyse auf den Nachrichten, wie zu erwarten war, erwies diese sich als schwierig, da die Tweets durch ihre Kürze selten leicht klassifizierbare Sätze enthalten.

## Änderung der Projektausrichtung
In Folge der oben Beschriebenen Probleme musste das Projekt in eine andere Richtung gelenkt werden, damit sichtbare Ergebnisse produziert werden können. Die Entscheidung fiel die Grundsätzliche Idee beizubehalten, dabei aber die Datenbasis zu ändern in der Hoffnung, dass diese die gewünschte Struktur aufweisen kann. Dazu wurden verschiedene Möglichkeiten evaluiert: Es existieren protokollierte Chatkorpora im _Dortmunder Chatkorpus_[5] zu verschiedenen Themen, etwa politische Diskussionen. Hier sind zwar Sprecher nachverfolgbar, jedoch weist ein klassischer Chat nicht die gewünschte Struktur auf, die verschiedene Richtungen der Konversation deutlich macht. Eine weitere Alternative wäre der Amazonrezensionskorpus[6] der Universität Stanford möglich gewesen. Zwar sind die Texte typischerweise länger, sodass eine Sentimentanalyse dort deutlich zuverlässiger funktionieren kann, aber die Beiträge beziehen sich selten aufeinander, sodass ein Zeitverlauf kaum sinnvoll erscheint.
Stattdessen fiel die Wahl auf _Disqus_[7] eine Kommentarplattform, die auf anderen Webseiten eingebunden werden kann, etwa in Blogs oder Nachrichtenseiten. Es werden dabei verschachtelte Gespräche möglich und eine vielfalt verschiedener Themen kann untersucht werden. Als zusätzlicher Vorteil gegenüber Twitter müssen die Daten nicht Live mitgeschnitten werden, sondern sind asynchron verfügbar. Die Textlängen variieren relativ stark, was für die Sentimentanalyse ein Hindernis sein kann, dies muss evaluiert werden. Auf dem Disqus eigenen Portal existieren weitere Diskussionsthemen unabhängig von externen Seiten. Die Verbreitung des Dienstes ermöglicht eine Bandbreite an verschiedenen Gesprächen zu betrachten, auch in sehr unterschiedlicher Größe. So gibt es Themen mit Beiträgen im zweistelligen Bereich, jedoch auch mehrere Tausend sind möglich.

### Datenbank
reicht eigentlich als kleiner punkt
* Daten sind stark strukturiert
* Daten vorhalten unnötig
* Deshalb keine persistente speicherung sondern nur in redis mit ablaufdatum
* die jsons werden dann nur für die anzeige verarbeitet

### Disqus-API
TODO evtl

### Gelöste Probleme
* muss nicht mehr zwischen prozessen kommunizieren, abfrage von disqus kann einfach im Hintergrund stattfinden
* klares Ende der diskussion, bzw. aktueller stand
* hierarchie möglich und sichtbar

https://dev.twitter.com/rest/public/search
https://dev.twitter.com/rest/reference/get/statuses/show/%3Aid
[3] https://dev.twitter.com/streaming/overview/connecting
[4] https://github.com/tweetstream/tweetstream
[5] http://www.chatkorpus.tu-dortmund.de/korpora.html
[6] https://snap.stanford.edu/data/web-Amazon.html
[7] https://disqus.com/home/discover/