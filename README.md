# RakutenTravel API sample application

## Usage rake tasks

### Area情報を取り込む

<pre>
bin/rake api:import_areas
</pre>

### Areaのenabledがtrueの地域におけるホテル情報を取得する

<pre>
bin/rake api:import_hotels
</pre>

### 指定したホテルNoの料金、部屋情報、プラン情報の取得

#### params

HOTEL_NO ... ホテルNo
CHECKIN ... チェックイン日(整数)
  ※ 1だと翌日チェックインを表す
COUNT ... 繰り返し回数
  ※ 3を指定し、CHECKINが 1だと 1日後, 2日後, 3日後をチェックする

<pre>
bin/rake api:research_by_hotel_no HOTEL_NO=509 CHECKIN=12 COUNT=3
</pre>

### 有効なホテルの料金、部屋情報、プラン情報の取得

<pre>
bin/rake api::import_charges CHECKIN=0 COUNT=90
</pre>