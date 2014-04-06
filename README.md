## RakutenTravel API samples

### Usage rake tasks

Area情報を取り込む

<pre>
bin/rake api:import_areas
</pre>

Areaのenabledがtrueの地域におけるホテル情報を取得する

<pre>
bin/rake api:import_hotels
</pre>

HOTEL_NO: 509の12日後, 13日後, 14日後の宿泊可能な部屋情報を取得する

<pre>
bin/rake api:research_by_hotel_no HOTEL_NO=509 CHECKIN=12 COUNT=3
</pre>
