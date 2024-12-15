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
  - **Backstory Body**: *Fake Nice Demo Version by Allouse Studio*

### Soundtracks
- [itch.io Soundtracks](https://itch.io/soundtracks)
- [Pixabay](https://pixabay.com/)
  - **Game Theme**: *Wrenwick*
  - **Item Selection Sound**: *amaze98*
  - **Realization Theme**: *Wrenwick*

### Images
- **Backgrounds**: *lynocs*
- **Player Character**: *penzilla*
- **Items**: TBD

---

## Development Roadmap

### Inventory System
- **Design**:
  - Visualize items in a **text box-style inventory** at the bottom of the screen.
  - Add items to the inventory dynamically as they are discovered.

### Hint Screen
- Update:
  - **Overall hint Button**: Proper Image.
  - **Order hint Button**: Proper Image.

### Back Buttons within the level
- Update:
  - Save mechanic so not restarting.

### Item Combination
- **Mechanics**:
  - Correct combinations unlock story progression.
  - Incorrect combinations penalize the player by reducing available time.

### Game Ending Scenarios
- **Item Order**:
  - **Correct Sequence**: Player wins.
  - **Incorrect or Partial Sequence**: Player loses.

---

## To-Do List

### Core Features
- [ ] Develop inventory system (Visuals) to display collected items.
- [ ] Update the hints screens with the proper images
- [ ] Fix back button to save the state of the game
- [ ] Create item combination mechanics.

### Level 1 Design
- [ ] Program item interactions.

### Player
- [ ] Fix going out of bounds 

### End Game Logic
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
- Fonts: *Salamahtype*, *Eunice*, *Allouse Studio*
- Soundtracks: *Wrenwick*, *amaze98*
- Visual Assets: *lynocs*, *penzilla*, TBD
