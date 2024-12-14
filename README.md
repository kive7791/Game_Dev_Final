# Game Development Final Project
## Game Title: **Lost Story**

### Overview
"Lost Story" is a 2D point-and-click adventure game where the player uncovers a story by locating and interacting with specific items. 
The game features a **choice-and-consequence system**:
- **Favorable Outcome**: Finding all items in the correct order unlocks the true ending.
- **Unfavorable Outcome**: Missing items, misordering items, or running out of time results in an unhappy ending.
- **Dynamic Atmosphere**: The game grows progressively creepier as the player delves deeper into the mystery.

**Planned Mechanics**:
- **Item Combinations**: Combining certain items unlocks parts of the story or reveals other items (time permitting).
- **Hints**: Items will glow red to hint at interactions.
- **Story Evolution**: Storyboards are subject to change as the storyline develops or puzzles are adjusted for feasibility.

---

## Resources

### Fonts
- [1001 Fonts](https://www.1001fonts.com/)
  - **Menu Title**: *Salamahtype*
  - **Menu Body**: *Eunice*

### Soundtracks
- [itch.io Soundtracks](https://itch.io/soundtracks)
- [Pixabay](https://pixabay.com/)
  - **Game Menu Theme**: *Wrenwick*
  - **Item Selection Sound**: *amaze98*
  - **Realization Theme**: *Wrenwick*

### Images
- **Backgrounds**: *lynocs*
- **Player Character**: *penzilla*
- **Items**: TBD

---

## Development Roadmap

### Start Screen
- **Structure**:
  - Display backstory before transitioning to Level 1.
  - Include a timer (e.g., 30 seconds or time sufficient for reading).
  - Auto-transition to Level 1 when the timer ends.
  - **Skip Button**: Allows players to immediately jump to Level 1.

### Inventory System
- **Design**:
  - Visualize items in a **text box-style inventory** at the bottom of the screen.
  - Add items to the inventory dynamically as they are discovered.

### Level 1
- **UI Features**:
  - Add a **Pause Button** at the top-right corner.

### Pause Screen
- Include:
  - **Hint Button**: Provides a gameplay hint.
  - **Quit Button**: Exits the game.

### Item Combination
- **Mechanics**:
  - Correct combinations unlock story progression.
  - Incorrect combinations penalize the player by reducing available time.

### Game Ending Scenarios
- **Timer**: Set to 5 minutes for the main gameplay.
  - **Time Runs Out**: Player loses.
- **Item Order**:
  - **Correct Sequence**: Player wins.
  - **Incorrect or Partial Sequence**: Player loses.

---

## To-Do List

### Core Features
- [ ] Implement start screen (after main menu) with backstory and timer.
- [ ] Add skip button to bypass backstory.
- [ ] Develop inventory system (Visuals) to display collected items.
- [ ] Implement pause screen with hint and quit functionality.
- [ ] Create item combination mechanics.

### Level 1 Design
- [ ] Add a pause button in the top-right corner.
- [ ] Program item interactions and glowing hints.

### Player
- [ ] Fix going out of bounds 

### End Game Logic
- [ ] Implement timer-based game-over condition.
- [ ] Create a recursive function to check:
  - If the player has all required items.
  - If the items are in the correct order.

### Resources Integration
- [ ] Finalize and integrate item visuals.
- [ ] Apply selected fonts and soundtracks to game assets.

---

## Notes
- The storyboards and mechanics may change as the game develops or puzzles are refined.
- Items glowing red will act as visual hints for player interactions.

---

## Credits
- Fonts: *Salamahtype*, *Eunice*
- Soundtracks: *Wrenwick*, *amaze98*
- Visual Assets: *lynocs*, *penzilla*, TBD
