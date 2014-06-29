# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Video.destroy_all
Category.destroy_all

comedies = Category.create(name: 'TV Comedies')
dramas = Category.create(name: 'TV Dramas')
reality = Category.create(name: 'Reality TV')

futurama = Video.create(
    title: 'Futurama',
    description: 'Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.',
    small_cover_url: '/tmp/futurama.jpg',
    category: comedies)

south_park = Video.create(
    title: 'South Park',
    description: 'Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.',
    small_cover_url: '/tmp/south_park.jpg',
    category: comedies)

family_guy = Video.create(
    title: 'Family Guy',
    description: 'Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.',
    small_cover_url: '/tmp/family_guy.jpg',
    category: comedies)

monk = Video.create(
    title: 'Monk',
    description: 'Adrian Monk is a brilliant San Francisco detective, whose obsessive compulsive disorder just happens to get in the way.',
    small_cover_url: '/tmp/monk.jpg',
    large_cover_url: '/tmp/monk_large.jpg',
    category: dramas)

salem = Video.create(
    title: 'Salem',
    description: "Set in the volatile world of 17th century Massachusetts, 'Salem' explores what really fueled the town's infamous witch trials and dares to uncover the dark, supernatural truth hiding behind the veil of this infamous period in American history. In Salem, witches are real, but they are not who or what they seem.",
    small_cover_url: '/tmp/salem.jpg',
    large_cover_url: '/tmp/salem_large.jpg',
    category: dramas)

penny_dreadful = Video.create(
    title: 'Penny Dreadful',
    description: "Explorer Sir Malcolm Murray, American gunslinger Ethan Chandler, and others unite to combat supernatural threats in Victorian London.",
    small_cover_url: '/tmp/penny_dreadful.jpg',
    large_cover_url: '/tmp/penny_dreadful_large.jpg',
    category: dramas)

game_of_thrones = Video.create(
    title: 'Game of Thrones',
    description: 'Seven noble families fight for control of the mythical land of Westeros.',
    small_cover_url: '/tmp/game_of_thrones.jpg',
    category: dramas)

silicon_valley = Video.create(
    title: 'Silicon Valley',
    description: "In the high-tech gold rush of modern Silicon Valley, the people most qualified to succeed are the least capable of handling success. A comedy partially inspired by Mike Judge's own experiences as a Silicon Valley engineer in the late 1980s.",
    small_cover_url: '/tmp/silicon_valley.jpg',
    category: dramas)

mozu = Video.create(
    title: 'MOZU Season1～百舌の叫ぶ夜～',
    description: 'サルドニア共和国大統領の来日の日がやってきた。
警護を指揮するのは、裏で大統領の暗殺を狙う公安部の室井（生瀬勝久）だ。
室井は警備計画の変更に左右されない場所で爆弾テロを起こす…そう睨む倉木（西島秀俊）たち。
しかし津城（小日向文世）は室井の策略で公安に拘束され、動くことが出来ない。
捜査第一課課長・村瀬（鶴見辰吾）を説得した大杉（香川照之）は、捜査一課の面々を引き連れ、大統領の到着する空港へ急行する。
まだ室井に撃たれた傷が治っていない美希（真木よう子）、また倉木も、それぞれ公安の監視を振り切って空港へたどり着く。
そして大勢の利用客で溢れる空港の中には、百舌・新谷宏美（池松壮亮）の姿もあった…。
大統領一家を乗せた旅客機が滑走路に降り立ち、空港では盛大な歓迎レセプションが始まる。
倉木は離れた場所から、捜査員たちと警護にあたる室井を監視する。
室井が単独で動き出せば、爆弾を起動させに行く可能性が高い。
倉木は爆弾の捜索を大杉に任せ、室井を尾行するが、その背後に室井の命を受けた公安部の村西（阿部力）が迫り…。',
    small_cover_url: '/tmp/mozu.jpg',
    large_cover_url: '/tmp/mozu_large.jpg',
    category: dramas)

kanbe = Video.create(
    title: '軍師官兵衛',
    description: '黒田官兵衛は、戦国乱世にあって一風変わった男だった。

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
          時代がこの男を必要としたからかもしれない―。',
    small_cover_url: '/tmp/kanbe.jpg',
    large_cover_url: '/tmp/kanbe_large.jpg',
    category: dramas)

arthur = User.create(email: 'arthur@intxtion.com', full_name: 'Arthur Pai', password: '1111', )
5.times { Fabricate(:review, video: kanbe, user: arthur) }