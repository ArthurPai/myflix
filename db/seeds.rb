# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

comedies = Fabricate(:category, name: 'TV Comedies')
dramas   = Fabricate(:category, name: 'TV Dramas')
reality  = Fabricate(:category, name: 'Reality TV')

image_directory = File.join(Rails.root, 'app/assets/images/covers')

futurama        = Fabricate(:video, title: 'Futurama',        category: comedies, small_cover: File.open(File.join(image_directory, 'futurama.jpg')))
south_park      = Fabricate(:video, title: 'South Park',      category: comedies, small_cover: File.open(File.join(image_directory, 'south_park.jpg')))
family_guy      = Fabricate(:video, title: 'Family Guy',      category: comedies, small_cover: File.open(File.join(image_directory, 'family_guy.jpg')))
monk            = Fabricate(:video, title: 'Monk',            category: dramas,   small_cover: File.open(File.join(image_directory, 'monk.jpg')), large_cover: File.open(File.join(image_directory, 'monk_large.jpg')), description:   'Adrian Monk is a brilliant San Francisco detective, whose obsessive compulsive disorder just happens to get in the way.')
salem           = Fabricate(:video, title: 'Salem',           category: dramas,   small_cover: File.open(File.join(image_directory, 'salem.jpg')), large_cover: File.open(File.join(image_directory, 'salem_large.jpg')), description: "Set in the volatile world of 17th century Massachusetts, 'Salem' explores what really fueled the town's infamous witch trials and dares to uncover the dark, supernatural truth hiding behind the veil of this infamous period in American history. In Salem, witches are real, but they are not who or what they seem.")
penny_dreadful  = Fabricate(:video, title: 'Penny Dreadful',  category: dramas,   small_cover: File.open(File.join(image_directory, 'penny_dreadful.jpg')), large_cover: File.open(File.join(image_directory, 'penny_dreadful_large.jpg')), description: 'Explorer Sir Malcolm Murray, American gunslinger Ethan Chandler, and others unite to combat supernatural threats in Victorian London.')
game_of_thrones = Fabricate(:video, title: 'Game of Thrones', category: dramas,   small_cover: File.open(File.join(image_directory, 'game_of_thrones.jpg')), description: 'Seven noble families fight for control of the mythical land of Westeros.')
silicon_valley  = Fabricate(:video, title: 'Silicon Valley',  category: dramas,   small_cover: File.open(File.join(image_directory, 'silicon_valley.jpg')), description: "In the high-tech gold rush of modern Silicon Valley, the people most qualified to succeed are the least capable of handling success. A comedy partially inspired by Mike Judge's own experiences as a Silicon Valley engineer in the late 1980s.")
mozu            = Fabricate(:video, title: 'MOZU Season1～百舌の叫ぶ夜～', category: dramas, small_cover: File.open(File.join(image_directory, 'mozu.jpg')), large_cover: File.open(File.join(image_directory, 'mozu_large.jpg')), description: 'サルドニア共和国大統領の来日の日がやってきた。
警護を指揮するのは、裏で大統領の暗殺を狙う公安部の室井（生瀬勝久）だ。
室井は警備計画の変更に左右されない場所で爆弾テロを起こす…そう睨む倉木（西島秀俊）たち。
しかし津城（小日向文世）は室井の策略で公安に拘束され、動くことが出来ない。
捜査第一課課長・村瀬（鶴見辰吾）を説得した大杉（香川照之）は、捜査一課の面々を引き連れ、大統領の到着する空港へ急行する。
まだ室井に撃たれた傷が治っていない美希（真木よう子）、また倉木も、それぞれ公安の監視を振り切って空港へたどり着く。
そして大勢の利用客で溢れる空港の中には、百舌・新谷宏美（池松壮亮）の姿もあった…。
大統領一家を乗せた旅客機が滑走路に降り立ち、空港では盛大な歓迎レセプションが始まる。
倉木は離れた場所から、捜査員たちと警護にあたる室井を監視する。
室井が単独で動き出せば、爆弾を起動させに行く可能性が高い。
倉木は爆弾の捜索を大杉に任せ、室井を尾行するが、その背後に室井の命を受けた公安部の村西（阿部力）が迫り…。')
kanbe           = Fabricate(:video, title: '軍師官兵衛', category: dramas, small_cover: File.open(File.join(image_directory, 'kanbe.jpg')), large_cover: File.open(File.join(image_directory, 'kanbe_large.jpg')), description: '黒田官兵衛は、戦国乱世にあって一風変わった男だった。

生涯五十幾度の合戦で一度も負けを知らなかった戦の天才だが、刀・槍や鉄砲ではなく、智力で敵を下す、それが官兵衛の真骨頂。

信長、秀吉、家康の三英傑に重用されながら、
あり余る才能がために警戒され、
秀吉には自分の次の天下人とまで恐れられた男、
それでも乱世を見事に生き抜き、九州福岡藩５２万石の礎を築いた男、その生き様ゆえに、
“生き残りの達人”と讃えられた男、それが黒田官兵衛である。

和歌や茶の湯を愛した文化人であり、
敬虔なキリスト教徒として信仰を貫き、
側室を持たずただ一人の妻と添い遂げた律儀な男。
一方で、権謀術数渦巻く戦国時代にあって、
巧みな弁舌と軍略で秀吉を支えた冷徹な軍師。

播州姫路に生まれた地方豪族の家老は
いつしか、天下一の軍師へと変貌する。
それは、乱れた世を正すために、
時代がこの男を必要としたからかもしれない―。')

arthur = Fabricate(:admin, email: 'arthur@intxtion.com', full_name: 'Arthur Pai')
moon   = Fabricate(:user, email: 'moon@intxtion.com', full_name: 'Moon')
kan    = Fabricate(:user, email: 'kan@intxtion.com', full_name: 'Kan')
kevin  = Fabricate(:user, email: 'kevin@intxtion.com', full_name: 'Kevin')
fiona  = Fabricate(:user, email: 'fiona@intxtion.com', full_name: 'Fiona')
mia    = Fabricate(:user, email: 'mia@intxtion.com', full_name: 'Mia')
vita   = Fabricate(:user, email: 'vita@intxtion.com', full_name: 'Vita')

[game_of_thrones, silicon_valley, mozu, kanbe, family_guy].each_with_index do |video, idx|
  Fabricate(:review, video: video, user: arthur, rating: 4, created_at: idx.days.ago)
end

[mozu, kanbe, futurama].each_with_index do |video, idx|
  arthur.queue_items.create(list_order: idx+1, video: video)
end

[south_park, futurama, family_guy].each_with_index do |video, idx|
  Fabricate(:review, video: video, user: moon, rating: 4, created_at: idx.days.ago)
  moon.queue_items.create(list_order: idx+1, video: video)
end

[kan, kevin].each do |people|
  arthur.followed_users << people
  fiona.followed_users << people
  mia.followed_users << people
end

[moon, vita, fiona, mia].each do |people|
  people.followed_users << arthur
  arthur.followed_users << people
end


