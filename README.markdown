Select people according to a skill and demand matrix

This library presents a small DSL-ish allowing you to specify a list of
candidates (your "bench"), to narrow the list by various criteria, and then to
draw up a roster of people selected from that list, reshuffling the list each
time the draw exhausts the winnowed bench.

Usage
-----

The library provides a monad you use to set up the bench and draw from it.
Within the RosterBuilder monad you `load` a list of people (implementing Person
typeclass) into the bench, then call `allocate` to choose people from it.

To constrain the group you're picking from, use the `restrict` action.

These are effectful actions; `label` outputs a text heading, and allocate
renders the people you've passed in, one per line. If you want to get at the
draw & reshuffle of a list, see Rosterium.Dealer's `allocateN` function.

A worked example of usage using the cast of _The Muppet Show_ in the
_`examples/`_ directory:

Pull in the library:

```haskell
import Rosterium.Allocatus
```

Use `roster` to enter the RosterBuilder monad and `load` a list of Persons:

```haskell
main :: IO ()
main = do
    roster $ do
        load performers
```

then `allocate` a number of them to task.


```haskell
        allocate 2
```

If you want to keep going just call `allocate` again. More likely you want to
limit the people being chosen between; use a predicate function over the list
of people on the bench:


```haskell
        label "Veterinarian's Hospital"
        load performers
        restrict charactersWithMedicalCostumes
        allocate 3
```

