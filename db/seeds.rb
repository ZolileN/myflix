# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Categories

comedies = Category.create(name: "TV Comedies")
dramas = Category.create(name: "TV Dramas")

#Videos

v1 = Video.create(title: "Futurama", description: "Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.", remote_small_cover_url: "http://s3.amazonaws.com/zacflix/uploads/futurama.jpg", remote_large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", categories: [comedies], video_url: "http://s3.amazonaws.com/zacflix/videos/Futurama+Premiere+Commercial.mp4")
v2 = Video.create(title: "South Park", description: "Follows the misadventures of four irreverent grade-schoolers in the quiet, dysfunctional town of South Park, Colorado.", remote_small_cover_url: "http://s3.amazonaws.com/zacflix/uploads/south_park.jpg", remote_large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", categories: [comedies], video_url: "http://s3.amazonaws.com/zacflix/videos/First+South+Park+Commercial+before+series+premiere%2C+1997.mp4")
v3 = Video.create(title: "Futurama", description: "Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.", remote_small_cover_url: "http://s3.amazonaws.com/zacflix/uploads/futurama.jpg", remote_large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", categories: [comedies], video_url: "http://s3.amazonaws.com/zacflix/videos/Futurama+Premiere+Commercial.mp4")
v4 = Video.create(title: "South Park", description: "Follows the misadventures of four irreverent grade-schoolers in the quiet, dysfunctional town of South Park, Colorado.", remote_small_cover_url: "http://s3.amazonaws.com/zacflix/uploads/south_park.jpg", remote_large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", categories: [comedies], video_url: "http://s3.amazonaws.com/zacflix/videos/First+South+Park+Commercial+before+series+premiere%2C+1997.mp4")
v5 = Video.create(title: "Futurama", description: "Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.", remote_small_cover_url: "http://s3.amazonaws.com/zacflix/uploads/futurama.jpg", remote_large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", categories: [comedies], video_url: "http://s3.amazonaws.com/zacflix/videos/Futurama+Premiere+Commercial.mp4")
v6 = Video.create(title: "South Park", description: "Follows the misadventures of four irreverent grade-schoolers in the quiet, dysfunctional town of South Park, Colorado.", remote_small_cover_url: "http://s3.amazonaws.com/zacflix/uploads/south_park.jpg", remote_large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", categories: [comedies], video_url: "http://s3.amazonaws.com/zacflix/videos/First+South+Park+Commercial+before+series+premiere%2C+1997.mp4")
v7 = Video.create(title: "Futurama", description: "Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.", remote_small_cover_url: "http://s3.amazonaws.com/zacflix/uploads/futurama.jpg", remote_large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", categories: [comedies], video_url: "http://s3.amazonaws.com/zacflix/videos/Futurama+Premiere+Commercial.mp4")
v8 = Video.create(title: "South Park", description: "Follows the misadventures of four irreverent grade-schoolers in the quiet, dysfunctional town of South Park, Colorado.", remote_small_cover_url: "http://s3.amazonaws.com/zacflix/uploads/south_park.jpg", remote_large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", categories: [comedies], video_url: "http://s3.amazonaws.com/zacflix/videos/First+South+Park+Commercial+before+series+premiere%2C+1997.mp4")

v9 = Video.create(title: "Monk", description: "Adrian Monk is a brilliant San Francisco detective, whose obsessive compulsive disorder just happens to get in the way.", remote_small_cover_url: "http://s3.amazonaws.com/zacflix/uploads/monk.jpg", remote_large_cover_url: "http://s3.amazonaws.com/zacflix/uploads/monk_large.jpg", categories: [dramas], video_url: "http://s3.amazonaws.com/zacflix/videos/Monk+commercial.mp4")
v10 = Video.create(title: "Monk", description: "Adrian Monk is a brilliant San Francisco detective, whose obsessive compulsive disorder just happens to get in the way.", remote_small_cover_url: "http://s3.amazonaws.com/zacflix/uploads/monk.jpg", remote_large_cover_url: "http://s3.amazonaws.com/zacflix/uploads/monk_large.jpg", categories: [dramas], video_url: "http://s3.amazonaws.com/zacflix/videos/Monk+commercial.mp4")
v11 = Video.create(title: "Monk", description: "Adrian Monk is a brilliant San Francisco detective, whose obsessive compulsive disorder just happens to get in the way.", remote_small_cover_url: "http://s3.amazonaws.com/zacflix/uploads/monk.jpg", remote_large_cover_url: "http://s3.amazonaws.com/zacflix/uploads/monk_large.jpg", categories: [dramas], video_url: "http://s3.amazonaws.com/zacflix/videos/Monk+commercial.mp4")

#Usersremote_
test_user = User.create(email: "test@user.com", full_name: "Test User", password: "user")
admin = User.create(email: "test@admin.com", full_name: "Test Admin", password: "admin", admin: true)
user2 = Fabricate(:user)
user3 = Fabricate(:user)

#Reviews
review1 = Fabricate(:review, user: test_user, video: v9)
review2 = Fabricate(:review, user: user2, video: v9)
review2 = Fabricate(:review, user: user3, video: v9)

#QueueItems
queue_item1 = Fabricate(:queue_item, user: test_user, video: v9, position: 1)
queue_item2 = Fabricate(:queue_item, user: test_user, video: v7, position: 2)
queue_item4 = Fabricate(:queue_item, user: user2, video: v7, position: 1)

#Relationships
relationship1 = Fabricate(:relationship, follower: user3, leader: user2)
relationship2 = Fabricate(:relationship, follower: test_user, leader: user2)
