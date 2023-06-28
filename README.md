# Top Soccer Teams Application

## **Overview**

This is a command-line application that is designed to process a stream of game results of a soccer league and output the top 3 teams at the end of each matchday. The tool should support input via stdin (pipe or redirect) or as a file path argument.

## Setup

1. Install ruby and bundler gem if not yet installed
2. Install Gems

   ```bash
   bundle install
   ```

3. Make the script executable:

   ```bash
   chmod +x ./bin/top_soccer_teams.rb
   ```

## Run Application

The are several ways to run this cli app.

1. Use filename as argument

   ```bash
   ./bin/top_soccer_teams.rb sample-input.txt
   ```

2. Use stdin pipe

   ```bash
   cat sample-input.txt | ./bin/top_soccer_teams.rb
   ```

3. Use stdin redirect

   ```bash
   ./bin/top_soccer_teams.rb < sample-input.txt
   ```

4. Use keyboard to type input manually

   ```bash
   ./bin/top_soccer_teams.rb
   ```

## Testing

The testing of this project is conducted with RSpec.

To run the tests

```bash
bundle exec rspec
```

The tests live in spec/game_results_processor_spec.rb, spec/league_spec.rb, and spec/team_spec.rb.

The tests cover the functionality of the classes, ensuring correct processing of game results, updating of team scores, and printing of top teams. The tests also cover handling invalid input lines and some edge cases, e.g., there are only 2 teams in the league.

## Requirements

The following is a summary of the requirements for the application. See PROMPT.md for details.

### Input

- Input can be provided in forms of:
  - stdin (pipe or redirect) if no input argument is provided.
  - file path if the first argument is provided.
- The input contains results of games, one per line and grouped by matchday.
- The input will be a valid utf-8 text, but can contains invalid results.
- It reads and processes game results
  - one at a time from the input stream.
  - handles input errors and skip invalid lines.
  - determines all teams in the league.
  - recognizes the start and end of a matchday with no specific delimiter between matchdays.
  - calculates and assigns points to teams based on game results.

### Output

- Output the result stream via stdout to the console.
- Output the top 3 teams, ranked by points and alphabetical order.
- Only output the result
  - at the end of each match day.
  - if the streaming data is interrupted in the middle of a matchday, that matchday should be considered as ended.

### Rules

- All teams play exactly once during a matchday.
- Wins are worth 3 points, draws are worth 1 point, and losses are worth 0 points.
- If multiple teams have the same number of points, they should be ranked alphabetically.

## Assumptions

- The number of teams in the league is even.
- Every team will play at every matchday.
- All valid game results are correct, which means it won’t break rules and assumptions above.

## **Architecture**

The project will follow a modular architecture, with separate classes for different responsibilities. The main components are as follows:

1. **`GameResultsProcessor`**:
   - Responsible for reading and processing the game results, printing desired output via stdout to the console at the right time.
   - Reads, validates, parses game results one line at a time from the input stream.
   - Delegates processing to the **`League`** class.
   - Prints the top teams at the end of each matchday.
   - Handles input data stream interruptions.
2. **`League`**:
   - Represents the soccer league and manages the teams.
   - Processes individual game results and updates team scores and top 3 teams.
   - Tracks the teams and their points using the **`Team`** class.
   - Prints the top teams at the end of each matchday.
3. **`Team`**:
   - Represents a team in the league.
   - Stores the team name and points.
   - Provides methods to update the team's points and compare teams for sorting.

## **Workflow**

1. The **`bin/top_soccer_teams.rb`** script acts as the entry point and initializes the **`GameResultsProcessor`**.
2. The **`GameResultsProcessor`** reads the game results from the input stream, line by line.
3. For each line, the **`GameResultsProcessor`** checks if it is a valid game result.
   1. If invalid, skip the line and continue processing the next line.
   2. If valid, continue to the next step.
4. The **`GameResultsProcessor`** parses the game result and passes it to the **`League`** class to continue processing.
5. The **`League`** processes the game result, updates the team points, and updates the top 3 teams.
6. If the **`League`** detects the end of a matchday, it prints the top 3 teams of that matchday in desired format. It then starts a new matchday.
7. Once the **`GameResultsProcessor`** finishes reading the input data stream, it determines if the input data was interrupted in the middle of a matchday. If yes, it will print the top 3 team of the last matchday.

## **Future Enhancements**

Here are some potential areas for future enhancements:

- Enhance the error handling mechanism to provide more informative error messages for invalid input lines. Adding some customized exceptions and adding more places to throw these exceptions may be a good direction to go.
- Enhance the test suite to cover additional edge cases, boundary conditions, and error scenarios. This ensures robustness and correctness of the tool in various scenarios. Test on large amount of data to see how the system scales.
- Handle situations when the assumptions are not correct.
