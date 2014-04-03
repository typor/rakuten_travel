# Create user
User.create!(email: 'example@example.com', password: 'password', password_confirmation: 'password')
# Create areas
Area.create!(long_name: '東京駅・銀座・日本橋', large: 'japan', middle: 'tokyo', small: 'tokyo', detail: 'A', enabled: true)
Area.create!(long_name: '新橋・汐留・お台場', large: 'japan', middle: 'tokyo', small: 'tokyo', detail: 'B', enabled: true)
Area.create!(long_name: '赤坂・六本木・麻布・永田町', large: 'japan', middle: 'tokyo', small: 'tokyo', detail: 'C', enabled: true)
Area.create!(long_name: '渋谷・青山・恵比寿・目黒', large: 'japan', middle: 'tokyo', small: 'tokyo', detail: 'D', enabled: true)
Area.create!(long_name: '品川・蒲田・羽田', large: 'japan', middle: 'tokyo', small: 'tokyo', detail: 'E', enabled: true)
Area.create!(long_name: '新宿・中野・杉並', large: 'japan', middle: 'tokyo', small: 'tokyo', detail: 'F', enabled: true)
Area.create!(long_name: '池袋・赤羽・板橋・練馬', large: 'japan', middle: 'tokyo', small: 'tokyo', detail: 'G', enabled: true)
Area.create!(long_name: '御茶ノ水・水道橋・飯田橋', large: 'japan', middle: 'tokyo', small: 'tokyo', detail: 'H', enabled: true)
Area.create!(long_name: '上野・浅草・両国・足立', large: 'japan', middle: 'tokyo', small: 'tokyo', detail: 'I', enabled: true)
Area.create!(long_name: '江東・江戸川・新小岩', large: 'japan', middle: 'tokyo', small: 'tokyo', detail: 'J', enabled: true)