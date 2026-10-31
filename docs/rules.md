# The 2026 variant, in plain words

MIT's 2026 game is heads-up Texas Hold'em with one twist. Each player gets three hole cards instead of two, and has to throw one away face up after the flop. The thrown card lands on the board, where both players can use it.

Everything below comes from reading `engine/engine.py` and `engine/config.py`, not from memory.

## The match

- Two bots, 1000 hands. The winner is the bot with more chips at the end.
- Every hand starts fresh at 400 chips each, so a bad hand costs at most 400. The score is the running total of what each hand won or lost.
- Blinds are 1 and 2.
- Seats swap every hand, so each bot is the small blind half the time.
- Each bot gets 60 seconds of thinking time for the whole match, not per move. If it runs out, it can only check or fold from then on, which loses the match.

## One hand, step by step

| Step | What happens | Board cards |
|---|---|---|
| Preflop | Each player gets 3 cards. The small blind acts first. Normal betting. | 0 |
| Flop | Only **2** cards come out, not 3. No betting yet. | 2 |
| Discard 1 | The big blind throws one of its 3 cards face up onto the board. | 3 |
| Discard 2 | The small blind throws one card, already knowing the big blind's discard. | 4 |
| Betting | First betting round after the discards. The big blind acts first. | 4 |
| Turn | One card, then betting. The big blind acts first. | 5 |
| River | One card, then betting. The big blind acts first. | 6 |
| Showdown | Each player makes the best 5-card hand from their 2 cards plus the 6 board cards. | 6 |

So the final board has six cards: four from the deck and the two discards. Whoever folds loses what they already put in.

## What a bot actually does

The engine asks the bot for a move, and the bot answers with one of five actions:

- `FoldAction()` gives up the hand.
- `CheckAction()` passes when there is nothing to call.
- `CallAction()` matches the other bot's bet.
- `RaiseAction(amount)` bets or raises to `amount`. It must sit between the limits from `round_state.raise_bounds()`.
- `DiscardAction(i)` throws away card `i` (0, 1 or 2) of your hand. It is only legal on the two discard steps, and on those steps it's the only legal move.

`round_state.legal_actions()` lists what's allowed right now. If a bot sends anything illegal or badly formatted, the engine checks for it when checking is legal and **folds** otherwise. A broken discard therefore folds the whole hand. That's why BS-02 ("a bot that never breaks") comes first.

## Why the twist matters

- **The discard is the big new decision.** You keep the two cards that work best with the board and with what your opponent might hold.
- **The big blind discards first and gives information away.** The small blind sees that card before choosing its own discard.
- **Every discard helps the opponent too.** Your thrown card is on the board for both of you. Throwing a card that completes their flush is a real mistake.
- **Hands get stronger than in normal Hold'em.** With 8 cards to choose from at showdown, two pair and better show up more often, so hands that are usually strong are worth less here.
