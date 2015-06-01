# Dokumentation TwitterProjekt
## Ursprüngliche Ziele
Kommunikation bei Twitter basiert auf 140 Zeichen langen Nachrichten von einem Sender zu beliebig vielen Empfängern. Zum Einen sind dies _Follower_, also Nutzer, die explizit Nachrichten des Senders erhalten wollen. Zum Anderen Beobachter bestimmter Themen (ursprünglich mit Hilfe von sogenannten _Hashtags_, Wörter mit vorangestelltem _#_).
Nutzer machten sich die Hashtags schnell zu Nutze und Diskussionen um ein Thema konnten mit Hilfe des Hashtags gesammelt werden. Direkter noch ist eine Antwort auf einen Tweet, wenn der Nutzername auf dessen Tweet sich bezogen wird in die Antwort eingebunden wird.
So können Diskussionen geführt werden, der Dienstanbieter selbst ermöglicht mittlerweile eine Ansicht, die es ermöglicht einen Gesprächsverlauf nachzuvollziehen, allerdings in recht begrenztem Umfang. Es ist dort nicht immer ganz klar welcher Tweet eine Antwort auf welchen ist und wieviele _Unterdiskussionen_ es gibt. Die Twitter-API enthält Informationen darüber, ob ein Tweet eine Antwort auf einen Anderen ist und wenn ja, welchen.
Ein Ziel dieses Projektes war die Ansicht des Diskussionsverlaufes Graphischer darzustellen. Gespräche sollten sich als Baumstrukturen aufbauen, sodass nachvollziehbarer ist, wer wann wem antwortet und wie es eventuell unterteilt ist.

Ein weiteres Ziel war die Inhaltliche Analyse der Tweets, mittels Sentimentanalyse sollten den einzelnen Tweets eine _Stimmung_ zugeordnet werden, ob diese zum Thema positiv, Negativ, oder Neutral gegenüber stehen. So war die Überlegung, dass bei einem Gesprächsverlauf eine generelle Verlagerung der Stimmung erkennbar sein könnte. Beispielsweise direkt in einem Twittergespräch oder Unterhaltungen parallel zu Fernsehübertragungen wie etwa Fußballspiele oder Ausstrahlung eines _Tatort_.


## Aufgekommene Probleme
### Twitter-API
Die Twitter-API bietet theoretisch viele Möglichkeiten auf Tweets zuzugreifen, insbesondere sticht hier die Suchfunktion[1] heraus, sie ermöglicht die Suche auf aktuellen und beliebten Tweets. Jedoch ist sie nicht vollständig, nach eigenen Angaben werden nicht alle passenden Tweets und User zurückgegeben. Auch einzelne Tweets können abgerufen werden[2]. Es wird stattdessen auf die _Streaming-API_ verwiesen, welche wir daher auch benutzten. Sie ist dreigeteilt, es gibt _User-Streams_, die in etwa die Sicht eines einzelnen Benutzers wiederspiegeln, _Site-Streams_, die dazu dienen anderen Applikationen Zugriff im Auftrag mehrerer Nutzer zu gewähren, und drittens _Public-Streams_ mit denen Nutzer oder Themen verfolgt werden können. Letztere wird auch explizit für Data-Mining-Verfahren empfohlen. Diese Public-Streams-API ermöglicht das Verfolgen von Tweets in Echtzeit, als Parameter kann man User-IDs, geographische Angaben oder bis zu 400 Keywords angeben. Für den Mechanismus wird HTTP POST verwendet und dabei die Sitzung offen gehalten, sodass Daten von Twitter an die verbundene Applikation ohne weitere Requests gesendet werden.

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
Die von Disqus übermittelten Daten sind im JSON-Format stark strukturiert. Sicherlich wäre es möglich diese Struktur in ein Datenbankschema zu überführen, da eine Threadvisualisierung einzeln für sich steht, können alle dafür notwendigen Daten im ganzen als JSON gespeichert werden und erst zur Verarbeitung interpretiert werden. Auch ein längerfristig persistentes Speichern ist nicht notwendig. Daher haben wir uns entschieden die Daten als Text in eine Redis-Datenbank[8] zu speichern. Sie sind dort mit einem Ablaufdatum versehen und werden dementsprechend nach Ablauf dieser gelöscht. Um auf bereits heruntergeladene Daten zuzugreifen wird als Schlüssel die abgefragte URL verwendet.

### Disqus-API
Disqus hat eine umfangreiche API[9], die es wohl ermöglicht eigene Clients zu entwickeln. Für unsere Zwecke benötigen wir lediglich zwei Methoden daraus: Zum einen __threads/listPosts__[10] und für Details zum Thread __threads/details__[11], wovon bisher ausschließlich der Threadname genutzt wird.
Um über die API einen Thread abrufen zu können, muss man diesen eindeutig identifizieren können. Dazu gibt es bei Disqus zwei Wege: Entweder über die __thread_id__ die Internetseite, welche Disqus einbindet,  mit einem Wort identifiziert, etwa _lawblog_. Um den Thread zu einem bestimmten Beitrag, etwa einem Blogpost zu identifizieren kommt dazu das Feld __thread_ident__.
Dagegen wird __thread_id__ auf Disqus-internen Foren verwendet.
Um diese notwendigen Daten in einem ersten Schritt zu laden wird ein __phantomjs__[12]-Skript verwendet. Damit wird die Seite im Hintergrund per Webkit gerendert, sodass die Felder ausgelesen werden können.
Der Zugangspunkt __threads/listPosts__ liefert dann alle Nutzerbeiträge zu dem angegebenen Thema. Dabei wird jeder Post über eine Zahl identifiziert und von Anderen als __parent__ referenziert, wenn diese eine Antwort auf ersteren sind. Darüber lässt sich im Nachhinein die Baumstruktur wieder aufbauen.

### Gelöste Probleme
Über die Disqus-API wird auf den aktuellen Zustand der Diskussion zugegriffen, dies war bei Twitter nicht im Nachhinein möglich, wie erwähnt war nur _streamen_ möglich, was jedoch zu neuen Problemen führte. Die Vereinfachung auf einen diskreten Zustand erleichtert die Programmlogik deutlich, Es gibt eine Phase, in der im Hintergrund die Daten geladen werden, danach können die Ergebnisse angezeigt werden.
In Disqus ist desweiteren die Threadansicht üblich, Nutzer können also genau bestimmen auf welchen Kommentar sie antworten. So treten Baumstrukturen hier wesentlich deutlicher auf und bieten sich so für Visualisierungen an.


## Evaluierung (sollen wir sowas machen?)
* qualität der sentimentanalyse
* visualisierung tree vs. sunburst
* aussagekraft der analyse → in den diskussionen scheint viel streit unter den teilnehmern zu herrschen, sehr viele beleidigungen → negatives sentiment
* verteilung der nutzeraktivität (kann man vielleicht bots erkennen? vielleicht welche, die häufig kommentieren, oder nur 1 mal) →zipfsch
* verteilung der thread-tiefe
* nutzer in threads, wie viele teilnehmer / thema
* die letzten punkte kann man eigentlich gut als ausblick nutzen, zeigen, was man analysieren könnte

## Quellen
[1] https://dev.twitter.com/rest/public/search

[2] https://dev.twitter.com/rest/reference/get/statuses/show/%3Aid

[3] https://dev.twitter.com/streaming/overview/connecting

[4] https://github.com/tweetstream/tweetstream

[5] http://www.chatkorpus.tu-dortmund.de/korpora.html

[6] https://snap.stanford.edu/data/web-Amazon.html

[7] https://disqus.com/home/discover/

[8] http://redis.io/

[9] https://disqus.com/api/docs/

[10] https://disqus.com/api/docs/threads/listPosts/

[11] https://disqus.com/api/docs/threads/details/

[12] http://phantomjs.org/
