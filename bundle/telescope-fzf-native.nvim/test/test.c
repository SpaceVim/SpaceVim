#include "fzf.h"

#include <examiner.h>
#include <stdlib.h>
#include <string.h>

typedef enum {
  ScoreMatch = 16,
  ScoreGapStart = -3,
  ScoreGapExtension = -1,
  BonusBoundary = ScoreMatch / 2,
  BonusNonWord = ScoreMatch / 2,
  BonusCamel123 = BonusBoundary + ScoreGapExtension,
  BonusConsecutive = -(ScoreGapStart + ScoreGapExtension),
  BonusFirstCharMultiplier = 2,
} score_t;

#define call_alg(alg, case, txt, pat, assert_block)                            \
  {                                                                            \
    fzf_position_t *pos = fzf_pos_array(0);                                    \
    fzf_result_t res = alg(case, false, txt, pat, pos, NULL);                  \
    assert_block;                                                              \
    fzf_free_positions(pos);                                                   \
  }                                                                            \
  {                                                                            \
    fzf_position_t *pos = fzf_pos_array(0);                                    \
    fzf_slab_t *slab = fzf_make_default_slab();                                \
    fzf_result_t res = alg(case, false, txt, pat, pos, slab);                  \
    assert_block;                                                              \
    fzf_free_positions(pos);                                                   \
    fzf_free_slab(slab);                                                       \
  }

static int8_t max_i8(int8_t a, int8_t b) {
  return a > b ? a : b;
}

#define MATCH_WRAPPER(nn, og)                                                  \
  fzf_result_t nn(bool case_sensitive, bool normalize, const char *text,       \
                  const char *pattern, fzf_position_t *pos,                    \
                  fzf_slab_t *slab) {                                          \
    fzf_string_t input = {.data = text, .size = strlen(text)};                 \
    fzf_string_t pattern_wrap = {.data = pattern, .size = strlen(pattern)};    \
    return og(case_sensitive, normalize, &input, &pattern_wrap, pos, slab);    \
  }

MATCH_WRAPPER(fuzzy_match_v2, fzf_fuzzy_match_v2);
MATCH_WRAPPER(fuzzy_match_v1, fzf_fuzzy_match_v1);
MATCH_WRAPPER(exact_match_naive, fzf_exact_match_naive);
MATCH_WRAPPER(prefix_match, fzf_prefix_match);
MATCH_WRAPPER(suffix_match, fzf_suffix_match);
MATCH_WRAPPER(equal_match, fzf_equal_match);

// TODO(conni2461): Implement normalize and test it here
TEST(FuzzyMatchV2, case1) {
  call_alg(fuzzy_match_v2, true, "So Danco Samba", "So", {
    ASSERT_EQ(0, res.start);
    ASSERT_EQ(2, res.end);
    ASSERT_EQ(56, res.score);

    ASSERT_EQ(2, pos->size);
    ASSERT_EQ(1, pos->data[0]);
    ASSERT_EQ(0, pos->data[1]);
  });
}

TEST(FuzzyMatchV2, case2) {
  call_alg(fuzzy_match_v2, false, "So Danco Samba", "sodc", {
    ASSERT_EQ(0, res.start);
    ASSERT_EQ(7, res.end);
    ASSERT_EQ(89, res.score);

    ASSERT_EQ(4, pos->size);
    ASSERT_EQ(6, pos->data[0]);
    ASSERT_EQ(3, pos->data[1]);
    ASSERT_EQ(1, pos->data[2]);
    ASSERT_EQ(0, pos->data[3]);
  });
}

TEST(FuzzyMatchV2, case3) {
  call_alg(fuzzy_match_v2, false, "Danco", "danco", {
    ASSERT_EQ(0, res.start);
    ASSERT_EQ(5, res.end);
    ASSERT_EQ(128, res.score);

    ASSERT_EQ(5, pos->size);
    ASSERT_EQ(4, pos->data[0]);
    ASSERT_EQ(3, pos->data[1]);
    ASSERT_EQ(2, pos->data[2]);
    ASSERT_EQ(1, pos->data[3]);
    ASSERT_EQ(0, pos->data[4]);
  });
}

TEST(FuzzyMatchV2, case4) {
  call_alg(fuzzy_match_v2, false, "fooBarbaz1", "obz", {
    ASSERT_EQ(2, res.start);
    ASSERT_EQ(9, res.end);
    int expected_score =
        ScoreMatch * 3 + BonusCamel123 + ScoreGapStart + ScoreGapExtension * 3;
    ASSERT_EQ(expected_score, res.score);
  });
}

TEST(FuzzyMatchV2, case5) {
  call_alg(fuzzy_match_v2, false, "foo bar baz", "fbb", {
    ASSERT_EQ(0, res.start);
    ASSERT_EQ(9, res.end);
    int expected_score =
        ScoreMatch * 3 + BonusBoundary * BonusFirstCharMultiplier +
        BonusBoundary * 2 + 2 * ScoreGapStart + 4 * ScoreGapExtension;
    ASSERT_EQ(expected_score, res.score);
  });
}

TEST(FuzzyMatchV2, case6) {
  call_alg(fuzzy_match_v2, false, "/AutomatorDocument.icns", "rdoc", {
    ASSERT_EQ(9, res.start);
    ASSERT_EQ(13, res.end);
    int expected_score = ScoreMatch * 4 + BonusCamel123 + BonusConsecutive * 2;
    ASSERT_EQ(expected_score, res.score);
  });
}

TEST(FuzzyMatchV2, case7) {
  call_alg(fuzzy_match_v2, false, "/man1/zshcompctl.1", "zshc", {
    ASSERT_EQ(6, res.start);
    ASSERT_EQ(10, res.end);
    int expected_score = ScoreMatch * 4 +
                         BonusBoundary * BonusFirstCharMultiplier +
                         BonusBoundary * 3;
    ASSERT_EQ(expected_score, res.score);
  });
}

TEST(FuzzyMatchV2, case8) {
  call_alg(fuzzy_match_v2, false, "/.oh-my-zsh/cache", "zshc", {
    ASSERT_EQ(8, res.start);
    ASSERT_EQ(13, res.end);
    int expected_score = ScoreMatch * 4 +
                         BonusBoundary * BonusFirstCharMultiplier +
                         BonusBoundary * 3 + ScoreGapStart;
    ASSERT_EQ(expected_score, res.score);
  });
}

TEST(FuzzyMatchV2, case9) {
  call_alg(fuzzy_match_v2, false, "ab0123 456", "12356", {
    ASSERT_EQ(3, res.start);
    ASSERT_EQ(10, res.end);
    int expected_score = ScoreMatch * 5 + BonusConsecutive * 3 + ScoreGapStart +
                         ScoreGapExtension;
    ASSERT_EQ(expected_score, res.score);
  });
}

TEST(FuzzyMatchV2, case10) {
  call_alg(fuzzy_match_v2, false, "abc123 456", "12356", {
    ASSERT_EQ(3, res.start);
    ASSERT_EQ(10, res.end);
    int expected_score = ScoreMatch * 5 +
                         BonusCamel123 * BonusFirstCharMultiplier +
                         BonusCamel123 * 2 + BonusConsecutive + ScoreGapStart +
                         ScoreGapExtension;
    ASSERT_EQ(expected_score, res.score);
  });
}

TEST(FuzzyMatchV2, case11) {
  call_alg(fuzzy_match_v2, false, "foo/bar/baz", "fbb", {
    ASSERT_EQ(0, res.start);
    ASSERT_EQ(9, res.end);
    int expected_score =
        ScoreMatch * 3 + BonusBoundary * BonusFirstCharMultiplier +
        BonusBoundary * 2 + 2 * ScoreGapStart + 4 * ScoreGapExtension;
    ASSERT_EQ(expected_score, res.score);
  });
}

TEST(FuzzyMatchV2, case12) {
  call_alg(fuzzy_match_v2, false, "fooBarBaz", "fbb", {
    ASSERT_EQ(0, res.start);
    ASSERT_EQ(7, res.end);
    int expected_score =
        ScoreMatch * 3 + BonusBoundary * BonusFirstCharMultiplier +
        BonusCamel123 * 2 + 2 * ScoreGapStart + 2 * ScoreGapExtension;
    ASSERT_EQ(expected_score, res.score);
  });
}

TEST(FuzzyMatchV2, case13) {
  call_alg(fuzzy_match_v2, false, "foo barbaz", "fbb", {
    ASSERT_EQ(0, res.start);
    ASSERT_EQ(8, res.end);
    int expected_score =
        ScoreMatch * 3 + BonusBoundary * BonusFirstCharMultiplier +
        BonusBoundary + ScoreGapStart * 2 + ScoreGapExtension * 3;
    ASSERT_EQ(expected_score, res.score);
  });
}

TEST(FuzzyMatchV2, case14) {
  call_alg(fuzzy_match_v2, false, "fooBar Baz", "foob", {
    ASSERT_EQ(0, res.start);
    ASSERT_EQ(4, res.end);
    int expected_score = ScoreMatch * 4 +
                         BonusBoundary * BonusFirstCharMultiplier +
                         BonusBoundary * 3;
    ASSERT_EQ(expected_score, res.score);
  });
}

TEST(FuzzyMatchV2, case15) {
  call_alg(fuzzy_match_v2, false, "xFoo-Bar Baz", "foo-b", {
    ASSERT_EQ(1, res.start);
    ASSERT_EQ(6, res.end);
    int expected_score = ScoreMatch * 5 +
                         BonusCamel123 * BonusFirstCharMultiplier +
                         BonusCamel123 * 2 + BonusNonWord + BonusBoundary;
    ASSERT_EQ(expected_score, res.score);
  });
}

TEST(FuzzyMatchV2, case16) {
  call_alg(fuzzy_match_v2, true, "fooBarbaz", "oBz", {
    ASSERT_EQ(2, res.start);
    ASSERT_EQ(9, res.end);
    int expected_score =
        ScoreMatch * 3 + BonusCamel123 + ScoreGapStart + ScoreGapExtension * 3;
    ASSERT_EQ(expected_score, res.score);
  });
}

TEST(FuzzyMatchV2, case17) {
  call_alg(fuzzy_match_v2, true, "Foo/Bar/Baz", "FBB", {
    ASSERT_EQ(0, res.start);
    ASSERT_EQ(9, res.end);
    int expected_score = ScoreMatch * 3 +
                         BonusBoundary * (BonusFirstCharMultiplier + 2) +
                         ScoreGapStart * 2 + ScoreGapExtension * 4;
    ASSERT_EQ(expected_score, res.score);
  });
}

TEST(FuzzyMatchV2, case18) {
  call_alg(fuzzy_match_v2, true, "FooBarBaz", "FBB", {
    ASSERT_EQ(0, res.start);
    ASSERT_EQ(7, res.end);
    int expected_score =
        ScoreMatch * 3 + BonusBoundary * BonusFirstCharMultiplier +
        BonusCamel123 * 2 + ScoreGapStart * 2 + ScoreGapExtension * 2;
    ASSERT_EQ(expected_score, res.score);
  });
}

TEST(FuzzyMatchV2, case19) {
  call_alg(fuzzy_match_v2, true, "FooBar Baz", "FooB", {
    ASSERT_EQ(0, res.start);
    ASSERT_EQ(4, res.end);
    int expected_score =
        ScoreMatch * 4 + BonusBoundary * BonusFirstCharMultiplier +
        BonusBoundary * 2 + max_i8(BonusCamel123, BonusBoundary);
    ASSERT_EQ(expected_score, res.score);
  });
}

TEST(FuzzyMatchV2, case20) {
  call_alg(fuzzy_match_v2, true, "foo-bar", "o-ba", {
    ASSERT_EQ(2, res.start);
    ASSERT_EQ(6, res.end);
    int expected_score = ScoreMatch * 4 + BonusBoundary * 3;
    ASSERT_EQ(expected_score, res.score);
  });
}

TEST(FuzzyMatchV2, case21) {
  call_alg(fuzzy_match_v2, true, "fooBarbaz", "oBZ", {
    ASSERT_EQ(-1, res.start);
    ASSERT_EQ(-1, res.end);
    ASSERT_EQ(0, res.score);
  });
}

TEST(FuzzyMatchV2, case22) {
  call_alg(fuzzy_match_v2, true, "Foo Bar Baz", "fbb", {
    ASSERT_EQ(-1, res.start);
    ASSERT_EQ(-1, res.end);
    ASSERT_EQ(0, res.score);
  });
}

TEST(FuzzyMatchV2, case23) {
  call_alg(fuzzy_match_v2, true, "fooBarbaz", "fooBarbazz", {
    ASSERT_EQ(-1, res.start);
    ASSERT_EQ(-1, res.end);
    ASSERT_EQ(0, res.score);
  });
}

TEST(FuzzyMatchV1, case1) {
  call_alg(fuzzy_match_v1, true, "So Danco Samba", "So", {
    ASSERT_EQ(0, res.start);
    ASSERT_EQ(2, res.end);
    ASSERT_EQ(56, res.score);

    ASSERT_EQ(2, pos->size);
    ASSERT_EQ(0, pos->data[0]);
    ASSERT_EQ(1, pos->data[1]);
  });
}

TEST(FuzzyMatchV1, case2) {
  call_alg(fuzzy_match_v1, false, "So Danco Samba", "sodc", {
    ASSERT_EQ(0, res.start);
    ASSERT_EQ(7, res.end);
    ASSERT_EQ(89, res.score);

    ASSERT_EQ(4, pos->size);
    ASSERT_EQ(0, pos->data[0]);
    ASSERT_EQ(1, pos->data[1]);
    ASSERT_EQ(3, pos->data[2]);
    ASSERT_EQ(6, pos->data[3]);
  });
}

TEST(FuzzyMatchV1, case3) {
  call_alg(fuzzy_match_v1, false, "Danco", "danco", {
    ASSERT_EQ(0, res.start);
    ASSERT_EQ(5, res.end);
    ASSERT_EQ(128, res.score);

    ASSERT_EQ(5, pos->size);
    ASSERT_EQ(0, pos->data[0]);
    ASSERT_EQ(1, pos->data[1]);
    ASSERT_EQ(2, pos->data[2]);
    ASSERT_EQ(3, pos->data[3]);
    ASSERT_EQ(4, pos->data[4]);
  });
}

TEST(ExactMatch, case1) {
  call_alg(exact_match_naive, true, "So Danco Samba", "So", {
    ASSERT_EQ(0, res.start);
    ASSERT_EQ(2, res.end);
    ASSERT_EQ(56, res.score);
  });
}

TEST(ExactMatch, case2) {
  call_alg(exact_match_naive, false, "So Danco Samba", "sodc", {
    ASSERT_EQ(-1, res.start);
    ASSERT_EQ(-1, res.end);
    ASSERT_EQ(0, res.score);
  });
}

TEST(ExactMatch, case3) {
  call_alg(exact_match_naive, false, "Danco", "danco", {
    ASSERT_EQ(0, res.start);
    ASSERT_EQ(5, res.end);
    ASSERT_EQ(128, res.score);
  });
}

TEST(PrefixMatch, case1) {
  call_alg(prefix_match, true, "So Danco Samba", "So", {
    ASSERT_EQ(0, res.start);
    ASSERT_EQ(2, res.end);
    ASSERT_EQ(56, res.score);
  });
}

TEST(PrefixMatch, case2) {
  call_alg(prefix_match, false, "So Danco Samba", "sodc", {
    ASSERT_EQ(-1, res.start);
    ASSERT_EQ(-1, res.end);
    ASSERT_EQ(0, res.score);
  });
}

TEST(PrefixMatch, case3) {
  call_alg(prefix_match, false, "Danco", "danco", {
    ASSERT_EQ(0, res.start);
    ASSERT_EQ(5, res.end);
    ASSERT_EQ(128, res.score);
  });
}

TEST(SuffixMatch, case1) {
  call_alg(suffix_match, true, "So Danco Samba", "So", {
    ASSERT_EQ(-1, res.start);
    ASSERT_EQ(-1, res.end);
    ASSERT_EQ(0, res.score);
  });
}

TEST(SuffixMatch, case2) {
  call_alg(suffix_match, false, "So Danco Samba", "sodc", {
    ASSERT_EQ(-1, res.start);
    ASSERT_EQ(-1, res.end);
    ASSERT_EQ(0, res.score);
  });
}

TEST(SuffixMatch, case3) {
  call_alg(suffix_match, false, "Danco", "danco", {
    ASSERT_EQ(0, res.start);
    ASSERT_EQ(5, res.end);
    ASSERT_EQ(128, res.score);
  });
}

TEST(EqualMatch, case1) {
  call_alg(equal_match, true, "So Danco Samba", "So", {
    ASSERT_EQ(-1, res.start);
    ASSERT_EQ(-1, res.end);
    ASSERT_EQ(0, res.score);
  });
}

TEST(EqualMatch, case2) {
  call_alg(equal_match, false, "So Danco Samba", "sodc", {
    ASSERT_EQ(-1, res.start);
    ASSERT_EQ(-1, res.end);
    ASSERT_EQ(0, res.score);
  });
}

TEST(EqualMatch, case3) {
  call_alg(equal_match, false, "Danco", "danco", {
    ASSERT_EQ(0, res.start);
    ASSERT_EQ(5, res.end);
    ASSERT_EQ(128, res.score);
  });
}

TEST(PatternParsing, empty) {
  fzf_pattern_t *pat = fzf_parse_pattern(CaseSmart, false, "", true);
  ASSERT_EQ(0, pat->size);
  ASSERT_EQ(0, pat->cap);
  ASSERT_FALSE(pat->only_inv);

  fzf_free_pattern(pat);
}

TEST(PatternParsing, simple) {
  fzf_pattern_t *pat = fzf_parse_pattern(CaseSmart, false, "lua", true);
  ASSERT_EQ(1, pat->size);
  ASSERT_EQ(1, pat->cap);
  ASSERT_FALSE(pat->only_inv);

  ASSERT_EQ(1, pat->ptr[0]->size);
  ASSERT_EQ(1, pat->ptr[0]->cap);

  ASSERT_EQ((void *)fzf_fuzzy_match_v2, pat->ptr[0]->ptr[0].fn);
  ASSERT_EQ("lua", ((fzf_string_t *)(pat->ptr[0]->ptr[0].text))->data);
  ASSERT_FALSE(pat->ptr[0]->ptr[0].case_sensitive);
  fzf_free_pattern(pat);
}

TEST(PatternParsing, withEscapedSpace) {
  fzf_pattern_t *pat = fzf_parse_pattern(CaseSmart, false, "file\\ ", true);
  ASSERT_EQ(1, pat->size);
  ASSERT_EQ(1, pat->cap);
  ASSERT_FALSE(pat->only_inv);

  ASSERT_EQ(1, pat->ptr[0]->size);
  ASSERT_EQ(1, pat->ptr[0]->cap);

  ASSERT_EQ((void *)fzf_fuzzy_match_v2, pat->ptr[0]->ptr[0].fn);
  ASSERT_EQ("file ", ((fzf_string_t *)(pat->ptr[0]->ptr[0].text))->data);
  ASSERT_FALSE(pat->ptr[0]->ptr[0].case_sensitive);
  fzf_free_pattern(pat);
}

TEST(PatternParsing, withComplexEscapedSpace) {
  fzf_pattern_t *pat =
      fzf_parse_pattern(CaseSmart, false, "file\\ with\\ space", true);
  ASSERT_EQ(1, pat->size);
  ASSERT_EQ(1, pat->cap);
  ASSERT_FALSE(pat->only_inv);

  ASSERT_EQ(1, pat->ptr[0]->size);
  ASSERT_EQ(1, pat->ptr[0]->cap);

  ASSERT_EQ((void *)fzf_fuzzy_match_v2, pat->ptr[0]->ptr[0].fn);
  ASSERT_EQ("file with space",
            ((fzf_string_t *)(pat->ptr[0]->ptr[0].text))->data);
  ASSERT_FALSE(pat->ptr[0]->ptr[0].case_sensitive);
  fzf_free_pattern(pat);
}

TEST(PatternParsing, withEscapedSpaceAndNormalSpace) {
  fzf_pattern_t *pat = fzf_parse_pattern(CaseSmart, false, "file\\  new", true);
  ASSERT_EQ(2, pat->size);
  ASSERT_EQ(2, pat->cap);
  ASSERT_FALSE(pat->only_inv);

  ASSERT_EQ(1, pat->ptr[0]->size);
  ASSERT_EQ(1, pat->ptr[0]->cap);
  ASSERT_EQ(1, pat->ptr[1]->size);
  ASSERT_EQ(1, pat->ptr[1]->cap);

  ASSERT_EQ((void *)fzf_fuzzy_match_v2, pat->ptr[0]->ptr[0].fn);
  ASSERT_EQ("file ", ((fzf_string_t *)(pat->ptr[0]->ptr[0].text))->data);
  ASSERT_FALSE(pat->ptr[0]->ptr[0].case_sensitive);

  ASSERT_EQ((void *)fzf_fuzzy_match_v2, pat->ptr[1]->ptr[0].fn);
  ASSERT_EQ("new", ((fzf_string_t *)(pat->ptr[1]->ptr[0].text))->data);
  ASSERT_FALSE(pat->ptr[1]->ptr[0].case_sensitive);
  fzf_free_pattern(pat);
}

TEST(PatternParsing, invert) {
  fzf_pattern_t *pat = fzf_parse_pattern(CaseSmart, false, "!Lua", true);
  ASSERT_EQ(1, pat->size);
  ASSERT_EQ(1, pat->cap);
  ASSERT_TRUE(pat->only_inv);

  ASSERT_EQ(1, pat->ptr[0]->size);
  ASSERT_EQ(1, pat->ptr[0]->cap);

  ASSERT_EQ((void *)fzf_exact_match_naive, pat->ptr[0]->ptr[0].fn);
  ASSERT_EQ("Lua", ((fzf_string_t *)(pat->ptr[0]->ptr[0].text))->data);
  ASSERT_TRUE(pat->ptr[0]->ptr[0].case_sensitive);
  ASSERT_TRUE(pat->ptr[0]->ptr[0].inv);
  fzf_free_pattern(pat);
}

TEST(PatternParsing, invertMultiple) {
  fzf_pattern_t *pat = fzf_parse_pattern(CaseSmart, false, "!fzf !test", true);
  ASSERT_EQ(2, pat->size);
  ASSERT_EQ(2, pat->cap);
  ASSERT_TRUE(pat->only_inv);

  ASSERT_EQ(1, pat->ptr[0]->size);
  ASSERT_EQ(1, pat->ptr[0]->cap);
  ASSERT_EQ(1, pat->ptr[1]->size);
  ASSERT_EQ(1, pat->ptr[1]->cap);

  ASSERT_EQ((void *)fzf_exact_match_naive, pat->ptr[0]->ptr[0].fn);
  ASSERT_EQ("fzf", ((fzf_string_t *)(pat->ptr[0]->ptr[0].text))->data);
  ASSERT_FALSE(pat->ptr[0]->ptr[0].case_sensitive);
  ASSERT_TRUE(pat->ptr[0]->ptr[0].inv);

  ASSERT_EQ((void *)fzf_exact_match_naive, pat->ptr[1]->ptr[0].fn);
  ASSERT_EQ("test", ((fzf_string_t *)(pat->ptr[1]->ptr[0].text))->data);
  ASSERT_FALSE(pat->ptr[1]->ptr[0].case_sensitive);
  ASSERT_TRUE(pat->ptr[1]->ptr[0].inv);
  fzf_free_pattern(pat);
}

TEST(PatternParsing, smartCase) {
  fzf_pattern_t *pat = fzf_parse_pattern(CaseSmart, false, "Lua", true);
  ASSERT_EQ(1, pat->size);
  ASSERT_EQ(1, pat->cap);
  ASSERT_FALSE(pat->only_inv);

  ASSERT_EQ(1, pat->ptr[0]->size);
  ASSERT_EQ(1, pat->ptr[0]->cap);

  ASSERT_EQ((void *)fzf_fuzzy_match_v2, pat->ptr[0]->ptr[0].fn);
  ASSERT_EQ("Lua", ((fzf_string_t *)(pat->ptr[0]->ptr[0].text))->data);
  ASSERT_TRUE(pat->ptr[0]->ptr[0].case_sensitive);
  fzf_free_pattern(pat);
}

TEST(PatternParsing, simpleOr) {
  fzf_pattern_t *pat = fzf_parse_pattern(CaseSmart, false, "'src | ^Lua", true);
  ASSERT_EQ(1, pat->size);
  ASSERT_EQ(1, pat->cap);
  ASSERT_FALSE(pat->only_inv);

  ASSERT_EQ(2, pat->ptr[0]->size);
  ASSERT_EQ(2, pat->ptr[0]->cap);

  ASSERT_EQ((void *)fzf_exact_match_naive, pat->ptr[0]->ptr[0].fn);
  ASSERT_EQ("src", ((fzf_string_t *)(pat->ptr[0]->ptr[0].text))->data);
  ASSERT_FALSE(pat->ptr[0]->ptr[0].case_sensitive);

  ASSERT_EQ((void *)fzf_prefix_match, pat->ptr[0]->ptr[1].fn);
  ASSERT_EQ("Lua", ((fzf_string_t *)(pat->ptr[0]->ptr[1].text))->data);
  ASSERT_TRUE(pat->ptr[0]->ptr[1].case_sensitive);
  fzf_free_pattern(pat);
}

TEST(PatternParsing, complexAnd) {
  fzf_pattern_t *pat = fzf_parse_pattern(CaseSmart, false,
                                         ".lua$ 'previewer !'term !asdf", true);
  ASSERT_EQ(4, pat->size);
  ASSERT_EQ(4, pat->cap);
  ASSERT_FALSE(pat->only_inv);

  ASSERT_EQ(1, pat->ptr[0]->size);
  ASSERT_EQ(1, pat->ptr[0]->cap);
  ASSERT_EQ(1, pat->ptr[1]->size);
  ASSERT_EQ(1, pat->ptr[1]->cap);
  ASSERT_EQ(1, pat->ptr[2]->size);
  ASSERT_EQ(1, pat->ptr[2]->cap);
  ASSERT_EQ(1, pat->ptr[3]->size);
  ASSERT_EQ(1, pat->ptr[3]->cap);

  ASSERT_EQ((void *)fzf_suffix_match, pat->ptr[0]->ptr[0].fn);
  ASSERT_EQ(".lua", ((fzf_string_t *)(pat->ptr[0]->ptr[0].text))->data);
  ASSERT_FALSE(pat->ptr[0]->ptr[0].case_sensitive);

  ASSERT_EQ((void *)fzf_exact_match_naive, pat->ptr[1]->ptr[0].fn);
  ASSERT_EQ("previewer", ((fzf_string_t *)(pat->ptr[1]->ptr[0].text))->data);
  ASSERT_EQ(0, pat->ptr[1]->ptr[0].case_sensitive);

  ASSERT_EQ((void *)fzf_fuzzy_match_v2, pat->ptr[2]->ptr[0].fn);
  ASSERT_EQ("term", ((fzf_string_t *)(pat->ptr[2]->ptr[0].text))->data);
  ASSERT_FALSE(pat->ptr[2]->ptr[0].case_sensitive);
  ASSERT_TRUE(pat->ptr[2]->ptr[0].inv);

  ASSERT_EQ((void *)fzf_exact_match_naive, pat->ptr[3]->ptr[0].fn);
  ASSERT_EQ("asdf", ((fzf_string_t *)(pat->ptr[3]->ptr[0].text))->data);
  ASSERT_FALSE(pat->ptr[3]->ptr[0].case_sensitive);
  ASSERT_TRUE(pat->ptr[3]->ptr[0].inv);
  fzf_free_pattern(pat);
}

static void score_wrapper(char *pattern, char **input, int *expected) {
  fzf_slab_t *slab = fzf_make_default_slab();
  fzf_pattern_t *pat = fzf_parse_pattern(CaseSmart, false, pattern, true);
  for (size_t i = 0; input[i] != NULL; ++i) {
    ASSERT_EQ(expected[i], fzf_get_score(input[i], pat, slab));
  }
  fzf_free_pattern(pat);
  fzf_free_slab(slab);
}

TEST(ScoreIntegration, simple) {
  char *input[] = {"fzf", "main.c", "src/fzf", "fz/noooo", NULL};
  int expected[] = {0, 1, 0, 1};
  score_wrapper("!fzf", input, expected);
}

TEST(ScoreIntegration, invertAnd) {
  char *input[] = {"src/fzf.c", "README.md", "lua/asdf", "test/test.c", NULL};
  int expected[] = {0, 1, 1, 0};
  score_wrapper("!fzf !test", input, expected);
}

TEST(ScoreIntegration, withEscapedSpace) {
  char *input[] = {"file ", "file lua", "lua", NULL};
  int expected[] = {0, 200, 0};
  score_wrapper("file\\ lua", input, expected);
}

TEST(ScoreIntegration, onlyEscapedSpace) {
  char *input[] = {"file with space", "file lua", "lua", "src", "test", NULL};
  int expected[] = {32, 32, 0, 0, 0};
  score_wrapper("\\ ", input, expected);
}

TEST(ScoreIntegration, simpleOr) {
  char *input[] = {"src/fzf.h",       "README.md",       "build/fzf",
                   "lua/fzf_lib.lua", "Lua/fzf_lib.lua", NULL};
  int expected[] = {80, 0, 0, 0, 80};
  score_wrapper("'src | ^Lua", input, expected);
}

TEST(ScoreIntegration, complexTerm) {
  char *input[] = {"lua/random_previewer", "README.md",
                   "previewers/utils.lua", "previewers/buffer.lua",
                   "previewers/term.lua",  NULL};
  int expected[] = {0, 0, 328, 328, 0};
  score_wrapper(".lua$ 'previewer !'term", input, expected);
}

static void pos_wrapper(char *pattern, char **input, int **expected) {
  fzf_slab_t *slab = fzf_make_default_slab();
  fzf_pattern_t *pat = fzf_parse_pattern(CaseSmart, false, pattern, true);
  for (size_t i = 0; input[i] != NULL; ++i) {
    fzf_position_t *pos = fzf_get_positions(input[i], pat, slab);
    if (!pos) {
      ASSERT_EQ((void *)pos, expected[i]);
      continue;
    }

    // Verify that the size is correct
    if (expected[i]) {
      ASSERT_EQ(-1, expected[i][pos->size]);
    } else {
      ASSERT_EQ(0, pos->size);
    }
    ASSERT_EQ_MEM(expected[i], pos->data, pos->size * sizeof(pos->data[0]));
    fzf_free_positions(pos);
  }
  fzf_free_pattern(pat);
  fzf_free_slab(slab);
}

TEST(PosIntegration, simple) {
  char *input[] = {"src/fzf.c",       "src/fzf.h",
                   "lua/fzf_lib.lua", "lua/telescope/_extensions/fzf.lua",
                   "README.md",       NULL};
  int match1[] = {6, 5, 4, -1};
  int match2[] = {6, 5, 4, -1};
  int match3[] = {6, 5, 4, -1};
  int match4[] = {28, 27, 26, -1};
  int *expected[] = {match1, match2, match3, match4, NULL};
  pos_wrapper("fzf", input, expected);
}

TEST(PosIntegration, invert) {
  char *input[] = {"fzf", "main.c", "src/fzf", "fz/noooo", NULL};
  int *expected[] = {NULL, NULL, NULL, NULL, NULL};
  pos_wrapper("!fzf", input, expected);
}

TEST(PosIntegration, andWithSecondInvert) {
  char *input[] = {"src/fzf.c", "lua/fzf_lib.lua", "build/libfzf", NULL};
  int match1[] = {6, 5, 4, -1};
  int *expected[] = {match1, NULL, NULL};
  pos_wrapper("fzf !lib", input, expected);
}

TEST(PosIntegration, andAllInvert) {
  char *input[] = {"src/fzf.c", "README.md", "lua/asdf", "test/test.c", NULL};
  int *expected[] = {NULL, NULL, NULL, NULL};
  pos_wrapper("!fzf !test", input, expected);
}

TEST(PosIntegration, withEscapedSpace) {
  char *input[] = {"file ", "file lua", "lua", NULL};
  int match1[] = {7, 6, 5, 4, 3, 2, 1, 0, -1};
  int *expected[] = {NULL, match1, NULL};
  pos_wrapper("file\\ lua", input, expected);
}

TEST(PosIntegration, onlyEscapedSpace) {
  char *input[] = {"file with space", "lul lua", "lua", "src", "test", NULL};
  int match1[] = {4, -1};
  int match2[] = {3, -1};
  int *expected[] = {match1, match2, NULL, NULL, NULL};
  pos_wrapper("\\ ", input, expected);
}

TEST(PosIntegration, simpleOr) {
  char *input[] = {"src/fzf.h",       "README.md",       "build/fzf",
                   "lua/fzf_lib.lua", "Lua/fzf_lib.lua", NULL};
  int match1[] = {0, 1, 2, -1};
  int match2[] = {0, 1, 2, -1};
  int *expected[] = {match1, NULL, NULL, NULL, match2};
  pos_wrapper("'src | ^Lua", input, expected);
}

TEST(PosIntegration, orMemLeak) {
  char *input[] = {"src/fzf.h", NULL};
  int match1[] = {2, 1, 0, -1};
  int *expected[] = {match1};
  pos_wrapper("src | src", input, expected);
}

TEST(PosIntegration, complexTerm) {
  char *input[] = {"lua/random_previewer", "README.md",
                   "previewers/utils.lua", "previewers/buffer.lua",
                   "previewers/term.lua",  NULL};
  int match1[] = {16, 17, 18, 19, 0, 1, 2, 3, 4, 5, 6, 7, 8, -1};
  int match2[] = {17, 18, 19, 20, 0, 1, 2, 3, 4, 5, 6, 7, 8, -1};
  int *expected[] = {NULL, NULL, match1, match2, NULL};
  pos_wrapper(".lua$ 'previewer !'term", input, expected);
}

int main(int argc, char **argv) {
  exam_init(argc, argv);
  return exam_run();
}
