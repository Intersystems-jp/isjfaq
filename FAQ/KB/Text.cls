/// 
/// Class KB.Text Extends %Text.Japanese
Class KB.Text Extends Text.MecabJapanese2
{

// Parameter NGRAMLEN = 10;

/// <PARAMETER>NGRAMLEN</PARAMETER> is the maximum number of words that will be regarded as a single 
/// search term.  When NGRAMLEN=2, two-word combinations will be added to any
/// index, in addition to single words.  Consecutive words exclude noise words.
/// 
Parameter NGRAMLEN = 5;

Parameter CASEINSENSITIVE = 1;

}
