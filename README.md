# Whistler Perx App

---

# Loyalty program practical example

At it's most basic, the platform offers clients the ability to issue loyalty points to their end users.
End users use their points to claim/purchase rewards offered by the client.

## Point Earning Rules

**Level 1**

1. For every $100 the end user spends they receive 10 points

**Level 2**

1. If the end user spends any amount of money in a foreign country they receive 2x the standard points

## Issuing Rewards Rules

**Level 1**

1. If the end user accumulates 100 points in one calendar month they are given a Free Coffee reward

**Level 2**

1. A Free Coffee reward is given to all users during their birthday month
2. A 5% Cash Rebate reward is given to all users who have 10 or more transactions that have an amount > $100
3. A Free Movie Tickets reward is given to new users when their spending is > $1000 within 60 days of their first transaction

## Loyalty Rules

**Level 1**

1. A standard tier customer is an end user who accumulates 0 points
2. A gold tier customer is an end user who accumulates 1000 points
3. A platinum tier customer is an end user who accumulates 5000 points

**Level 2**

1. Points expire every year
2. Loyalty tiers are calculated on the highest points in the last 2 cycles
2. Give 4x Airport Lounge Access Reward when a user becomes a gold tier customer
3. Every calendar quarterly give 100 bonus points for any user spending greater than $2000 in that quarter

## Evaluation

You are expected to create a git repository (in github or equivalent) and share the repository details with us.
The way you manage your commits is up to you, but we would like to have the opportunity to see how is
your workflow like.
Your code will be evaluated more on the quality than on completing the scope.
Our production environment is a high volume environment, we are required to maintain data integrity and performance throughout.
Please provide appropriate tests.

---

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
