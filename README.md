# Whistler Perx App

In fulfillment of the Perx 2nd interview requirements for RoR engineer role.

## Scope of work

On the surface, these are the main high level operations that this app needs to perform. I've broken them down into something easier to digest

1. As a user, I can complete transactions in the app by passing in relevant information
2. As system, I will issue rewards and upgrade loyalty tiers accordingly
3. As system, I have time-related tasks to be executed

For no.2, we can just refer to the main document as it has outlined the main requirements. There were a assumptions I have to make due to lack of clarity. In working world, all uncertainties should be addressed first with the PM/stakeholders ASAP before moving forward.

1. "Points expire every year" - I treat this as a yearly campaign where all user points will reset on Jan 1st
2. "Loyalty tiers are calculated on the highest points in the last 2 cycles" - I treat this as to mean that the tiers are calculated based on the current accumulated points + the highest accumulated points recorded between the last 2 years. I figured I shouldn't overthink this and then overcomplicate the mechanics.
3. Rewards are reusable. i.e. the `Free Coffee` reward can be awarded for birthday and for getting 100 points in a month
4. "For every $100 the end user spends they receive 10 points" - I treat it to mean it's not cumulative. So if a user spends SGD$150 and SGD$150 in separate transactions, they will earn 20 points. Otherwise there will be more logic involving bringing forward the remainder and keeping track of its currency.
5. When user jumps straight from `standard` to `platinum`, they are not awarded with the 4x Airport Lounge Access reward. Just to keep things simple.

## Thought process

There are many processes that happens one after the other, making sure that they all run quick and without blocking the frontend is crucial for a seamless experience. Hence, the use of a Sidekiq workers running on Redis to process the data in the background rather than directly in the controller.

The services are abstraction to keep all inter-related logic in one place. So in the future, if there are more rewards to be added or changed, it can be done here. More details shared in the codebase itself.

## DB schema

[dbdiagram.io is my go to app](https://dbdiagram.io/d/62bbfc4f69be0b672c62b94e)

## Setting up the app

0. Install Redis if you haven't
1. Clone this repo
2. Run `bundle`
3. Run `rails db:setup`
4. Run `bundle exec rspec` to run RSpec tests
5. Run `bundle exec sidekiq` to run Sidekiq
6. Run `rails s` to start
7. In something like postman or in cUrl, make a request to `POST http://localhost:3000/transactions` and payload
```json
{
  "user_id": 1, // seeded user id
  "currency": "SGD", // or "BND", "USD" to get 2x
  "amount": 100,
  "description": "Gongcha Pearl Milk Tea x10"
}
```
8. Run `rails c` to check for changes in the DB tables

## Closing thoughts

Overall, I found myself spending a bit too much time looking for ways to optimize/refactoring further but alas due to time constraint, I've submitted this as an MVP-ish working product. It's an enjoyable project and sets a blank canvas just like when starting a new project.
