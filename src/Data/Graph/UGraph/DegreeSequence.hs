module Data.Graph.UGraph.DegreeSequence
    (
    DegreeSequence

    -- * Construction
    , degreeSequence
    , getDegreeSequence

    -- * Queries
    , isGraphicalSequence
    -- , isDirectedGraphic
    , holdsHandshakingLemma

    -- * Graph generation
    -- , fromGraphicalSequence
    ) where

import Data.List (reverse, sort)

import Data.Hashable

import Data.Graph.Types
import Data.Graph.UGraph

-- | The Degree Sequence of a simple 'UGraph' is a list of degrees of the
-- vertices in the graph
--
-- Use 'degreeSequence' to construct a valid Degree Sequence
newtype DegreeSequence = DegreeSequence { unDegreeSequence :: [Int]}
    deriving (Eq, Ord, Show)

-- | Construct a 'DegreeSequence' from a list of degrees. Negative degree values
-- get discarded
degreeSequence :: [Int] -> DegreeSequence
degreeSequence = DegreeSequence . reverse . sort . filter (>0)

-- | Get the 'DegreeSequence' of a simple 'UGraph'. If the graph is not @simple@
-- (see 'isSimple') the result is Nothing
getDegreeSequence :: (Hashable v, Eq v) => UGraph v e -> Maybe DegreeSequence
getDegreeSequence g
    | (not . isSimple) g = Nothing
    | otherwise = Just $ degreeSequence $ degrees g

-- | Tell if a 'DegreeSequence' is a Graphical Sequence
--
-- A Degree Sequence is a @Graphical Sequence@ if a corresponding 'UGraph' for
-- it exists. Uses the Havel-Hakimi algorithm
isGraphicalSequence :: DegreeSequence -> Bool
isGraphicalSequence (DegreeSequence []) = True
isGraphicalSequence (DegreeSequence (x:xs))
    | x > length xs = False
    | otherwise = isGraphicalSequence $ degreeSequence seq'
        where seq' = subtract 1 <$> take x xs ++ drop x xs

-- | Tell if a 'DegreeSequence' is a Directed Graphic
--
-- A @Directed Graphic@ is a Degree Sequence for which a 'DGraph' exists
-- TODO: Kleitman–Wang | Fulkerson–Chen–Anstee theorem algorithms
isDirectedGraphic :: DegreeSequence -> Bool
isDirectedGraphic = undefined

-- | Tell if a 'DegreeSequence' holds the Handshaking lemma, that is, if the
-- number of vertices with odd degree is even
holdsHandshakingLemma :: DegreeSequence -> Bool
holdsHandshakingLemma = even . length . filter odd . unDegreeSequence

-- | Get the corresponding 'UGraph' of a 'DegreeSequence'. If the
-- 'DegreeSequence' is not graphical (see 'isGraphicalSequence') the result is
-- Nothing
fromGraphicalSequence :: DegreeSequence -> Maybe (UGraph Int ())
fromGraphicalSequence = undefined
