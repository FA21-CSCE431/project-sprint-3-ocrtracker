# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

############ Exercises #############

User.find_or_create_by(email: 'test-user@tamu.edu').update({

                                                             full_name: 'test user',
                                                             uid: '12376y1245098162308412',
                                                             is_admin: true,
                                                             description: 'test-description'
                                                           })

e1 = Exercise.find_or_create_by({
                                  title: 'Pushups',
                                  description: 'A push-up is a common calisthenics exercise beginning from the prone'\
                                  ' position. By raising and lowering thebody using the arms, push-ups exercise'\
                                  ' the pectoral muscles, triceps, and anterior deltoids, with ancillary benefits'\
                                  ' to the rest of the deltoids, serratus anterior, coracobrachialis and the'\
                                  ' midsection as a whole.',
                                  picture: 'https://www.thehindu.com/sci-tech/health/vsuju8/article34301845.ece/ALTERNATES/LANDSCAPE_1200/10MPHowto1',
                                  unit_name: 'time_l_to_h'
                                })

e2 = Exercise.find_or_create_by({
                                  title: 'Situps',
                                  description: 'The sit-up is an abdominal endurance training exercise to strengthen,'\
                                  ' tighten and tone the abdominal muscles. It is similar to a crunch, but sit-ups'\
                                  ' have a fuller range of motion and condition additional muscles.',
                                  picture: 'https://cdn.mos.cms.futurecdn.net/4ogwV6zhannpcVUyKZMc9K-480-80.jpg',
                                  unit_name: 'quantity'
                                })

############ Workout Posts #############

wp1 = WorkoutPost.find_or_create_by({
                                      title: 'Workout Post 1'
                                    })

############ Exercise Posts #############

ep1 = ExercisePost.find_or_create_by({
                                       exercise: e1,
                                       workout_post: wp1,
                                       specific_instructions: '50 pushups',
                                       is_ranked: true
                                     })

ep2 = ExercisePost.find_or_create_by({
                                       exercise: e2,
                                       workout_post: wp1,
                                       specific_instructions: 'As many situps as you can',
                                       is_ranked: false
                                     })

############ Workout Submissions #############

ws1 = WorkoutSubmission.find_or_create_by({
                                            user: User.first,
                                            workout_post: wp1,
                                            submitted_datetime: DateTime.new(2021, 10, 1, 2, 3, 4)
                                          })

############ Exercise Submissions #############

ExerciseSubmission.find_or_create_by({
                                       exercise_post: ep1,
                                       workout_submission: ws1,
                                       unit_value: '180',
                                       user: ws1.user
                                     })

ExerciseSubmission.find_or_create_by({
                                       exercise_post: ep2,
                                       workout_submission: ws1,
                                       unit_value: '120',
                                       user: ws1.user
                                     })
