# pokerbot

My pokerbot for the MIT Pokerbots 2026 variant: no-limit Hold'em where each player gets 3 hole cards and discards one face up after the flop. Heads-up, 1000 hands, 400-chip stacks.

- `engine/`: the official [MIT engine](https://github.com/mitpokerbots/engine-2026) (submodule, not modified).
- `references/ref1-3/`: MIT's three reference bots (submodules). They're the ladder to beat: toss-smallest, good-cards, Monte Carlo.
- `bots/juanbot/`: my bot, which starts from the Python skeleton.
- `kanvas.json`: the project plan, on a [Kanvas](https://github.com/XMihura/Kanvas) board.

## Play a match

```bash
git clone --recurse-submodules https://github.com/juanorbea/pokerbot
cd pokerbot
scripts/match.sh bots/juanbot references/ref1/python_toss_smallest 1000
```

It needs [uv](https://docs.astral.sh/uv/). It prints the final score, and the full log is saved under `matches/`.
