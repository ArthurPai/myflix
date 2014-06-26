# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Video.destroy_all
Category.destroy_all

commedies = Category.create(name: 'TV Commedies')
dramas = Category.create(name: 'TV Dramas')
reality = Category.create(name: 'Reality TV')

monk = Video.create(
    title: 'monk',
    description: 'Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.',
    small_cover_url: '/tmp/monk.jpg',
    large_cover_url: '/tmp/monk_large.jpg')

futurama = Video.create(
    title: 'Futurama',
    description: 'Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.',
    small_cover_url: '/tmp/futurama.jpg')

south_park = Video.create(
    title: 'South Park',
    description: 'Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.',
    small_cover_url: '/tmp/south_park.jpg')

family_guy = Video.create(
    title: 'Family Guy',
    description: 'Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.',
    small_cover_url: '/tmp/family_guy.jpg')

commedies.videos << monk
dramas.videos << futurama
reality.videos << south_park << family_guy