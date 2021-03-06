# README

Ruby version: 2.3.5

# Purpose
Track the stableford scores of golf games, and adjust player handicaps based on
the the best 5 of the most recent 10 rounds. Handicaps will be adjusted when,
using the player's current handicap, their 5 best rounds either average below 34
(handicap will go up), or those rounds average above 36.5 (handicap will go down).

# TODO
- [x] Add admins and logins to protect editing of handicaps
- [x] Streamline "Post scores" page -- remove history from this page
- [x] Create a summary page that shows only the players who have changed handicaps on a given day
  - [x] Show old _and_ new handicap
- [x] Create "read only" view that shows player history
  - [ ] Maybe add chart of individual score/handicap history?
- [x] Limit handicaps to 26
- [ ] Only allow the removal of the most recent round
  - [x] When removing a round, reset the handicap
- [ ] Bonus: Medical button to track medical rounds, but does not show up on public side
- [ ] Add multiple scores at once for once golfer
- [x] Fix totals to be scores based on current handicap
- [x] Add back round handicaps to rounds page and golfer's round's page
- [x] Change "Post scores" to "New scores"
