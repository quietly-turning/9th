# Symphony No. 9

A stepchart to excerpts from Beethoven's 9th Symphony, in which the
player cannot hear the music, but creates sonic vibrations with their
feet, not unlike those felt by Ms. Helen Keller with her hand on her
radio a hundred years ago.

I had two goals in mind while making this stepchart:
  1. to acknowledge the position + influence I have as a dance game
     community leader and use it to get my audience thinking about
     accessibility
  2. to share something beautiful with the world

With this readme.txt, I'd like to provide some background on the
material, explain my interest in it, briefly touch on technical
implementation details, and note my hopes for what this stepchart can
be.





## A little about me

Since 2020, I've been employed as a software developer.  My favorite
area to work in application development is accessibility — keyboard
navigation, touch navigation, color and contrast considerations, screen
readers, and so on.  I love using my time on this earth to move the
needle of the-state-of-computer-software a little towards a more
accessible place.

It's frustrating that Tech™ doesn't seem motivated by this sentiment.
The tickets I work on are never about accessibility, but I carve out
time to include it in every pull request I submit regardless.  My
employer put out an internal request for employees to write blogposts
the company could share to shape SEO and drive sales (and whatever
myriad reasons companies blog in 2025), and I wrote about how I've
worked accessibility into our software, and curiously they opted not to
share that one on our company website.

Back in uni, one of my classmates was blind, and brought his seeing-eye
dog to class.  He expressed frustration that the Windows 8 calculator
app wasn't screen-reader-accessible, making it impossible for him to
use, and used a particular class project to demonstrate to us how he was
using screen-reader software to write code to create a
screen-reader-accessible calculator app.

That stays with me, and motivates me today to improve what I can.





## About Ms. Keller's Letter

I first came across Ms. Keller's 1924 letter to her local NYC radio
station about their performance of Beethoven's 9th Symphony in 2015,
when I was a university student, through the blog lettersofnote.com.
That blog post is archived here; I recommend reading it in full!
https://web.archive.org/web/20140330221339/http://www.lettersofnote.com/2014/03/my-heart-almost-stood-still.html

I was immediately struck by the letter's evocative, poetic language.
The way she described the play-by-play of listening to symphony, I felt
as though I were listening alongside her.  I'd known of Ms. Keller from
elementary school history, but had no idea she was such an incredible
writer.  Her letter stirred my heart.

I first had the idea for this stepchart then, in 2015, almost exactly as
it appears today — players hitting notes to an excerpt of Beethoven's
9th Symphony they cannot hear as a voice actor reads Ms. Keller's letter.
My interest then was strictly emotional; some men just want to watch the
world yearn.

In the decade since, I've become more familiar with Ms. Keller's life
and work, as a writer and activist for causes ranging from women's
suffrage to political socialism to birth control to rights for disabled
folks — topics which sadly remain contentious in 2025.

Her 1932 letter responding to a question asking what she saw from the
top of the Empire State Building bears resemblance to her 9th Symphony
letter in poetic tone, but comes out more strongly in defense of herself
as an advocate for anyone who would question, or discredit, disabled
folks.
https://web.archive.org/web/20140703153026/http://www.lettersofnote.com/2012/03/empire-state-building.html

I can't speak for Ms. Keller, but I choose to believe she wrote letters
like these both because she enjoyed her craft and was good at it — the
delight in choosing precisely the right word to elicit or ignite a
feeling in a reader! — and because she recognized the position she was
in as a public figure the public paid attention to.  She surely knew she
could move the needle in a little bit of a better direction if she stood
up for what she believed in.

That's what I see and feel in her writing.

While working on this stepchart in 2025, I wanted to both evoke a
feeling in my audience — to stir their hearts as the letter had mine a
decade earlier — and to get my audience thinking about accessibility.






## About Accessibility in Software

Inclusivity is the right thing to do, and it can be designed for.

I used to believe things like "there are certain things vision-impaired
people won't be able to do" and "the target audience for my software
doesn't include vision-impaired people." But this was only because I'd
never seen anyone explicitly design for accessibility.

Computer Software would be "impossible" if no one worked to design and
build it. I only thought there were certain digital interactions
vision-impaired people couldn't do because I'd never seen anyone work to
design and build experiences for them.

TLoU Part 2's accessibility options are a fantastic example of designing
for accessibility, and (in my opinion) represent the current State Of
The Art. This is genuinely inspiring stuff I think you should check out:  
https://www.youtube.com/watch?v=PWJhxsZb81U&t=746s






## About Beethoven's 9th Symphony

I grew up listening to a lot of classical music.  The 2nd movement of
Beethoven's 9th got regular play in my Winamp install in early 2000s,
sandwiched between Fatboy Slim's Praise You and Len's Steal My Sunshine,
as I stayed up late to talk with my crush on AIM.

I didn't think much of it then.  I'd always known classical music since
I could remember, as there were always Chopin and Mozart and Beethoven
CDs around the house that had been gifted to my physician father by drug
company reps trying to sell their pills.  This was pre-Napster,
pre-internet, pre-me-being-able-to-leave-the-house-and-make-decisions-for
-myself.

I better understand now: not many children listen to a lot of classical
music growing up. :)

But for me, Beethoven's 9th is a song I'm very familiar with.  I
certainly hear the song in my head when I play this silent stepchart,
though I don't expect anyone else will.

To that end — I've included "9th.ogg" in the normal-stepchart-assets
folder, which is roughly what I used when creating this stepchart.  It
includes short excerpts from the 1st, 2nd, and 4th movements.  Give it a
listen!

If you want, you could even edit the ssc file's #MUSIC tag for the
challenge stepchart to be 
  #MUSIC:normal-stepchart-assets/9th.ogg;
and that should work.

Finally, it sucks that some people have appropriated Beethoven's works
and other classical pieces for racist ideologies.  I'd be remiss not to
address it here.

Adam Neely has a good video essay on this topic:  
https://youtu.be/Kr3quGh7pJA?t=1329

Jon Batiste tactfully hints at this in an NPR interview:  
https://youtu.be/5_oZa5200II?t=376

I think it's fine to like songs like Beethoven's 9th Symphony, but that
it's important — *especially* if you the reader are a relatively
well-off white man — to acknowledge it's not the definition of good
music, and that you owe it to yourself as a citizen of the broader world
to seek out new music you're unfamiliar with.





## Technical Implementation Notes

This stepchart was a lot of manual work!  I come away with a much
greater appreciation for what limited tooling exists for content
creators working with fonts in the StepMania/ITGmania engine in 2025.

All of the fonts in FGCHANGES/fonts were manually created by me using:
  * Affinity Photo 2 to arrange a grid of characters and export to png
  * a text editor to create the ini file and manually type in each
    character width
  * Affinity Photo 2's ruler tool to manually measure each character's width

This was very tedious and painstaking!

I also learned that as of 2025, StepMania/ITGmania's in-game font
rendering does not support certain diacritic-heavy fonts like Thai
script, where the alphabet characters and the diacritic characters are
separate unicode codepoints, and it's up to the font renderer to
superimpose the diacritic gylphs atop the alphabet glyphs!  I sure did
spend a lot of time going down a rabbit hole 1. figuring that out, and
2. trying to get a hacky solution working with negative pixel values for
diacritic widths in Thai.ini...

Ultimately, to support Thai in this stepchart, I laid out entire
sentences as frames of a large spritesheet and wrote a secondary system
to cycle through that.  It'd be great if StepMania/ITGmania properly
supports scripts like Thai in the future. 👍

One planned feature I ran out of time on was letting each player choose
their own subtitle language, and presenting those subtitles with their
player-specific notefield.  Ah well.

Another planned feature was including a Latin American Spanish voice
actor, but I ran out of money.

* en-A's voice actor is Juliet Stevenson  
   from the "Letters of Note: Music" audiobook
* en-B's voice actor is anonymous
* jp's voice actor is Machiko Ejiri  
   https://www.voices.com/profile/machikoejiri


One small regret I have with this stepchart is not making time to clean
up my code into something sensible before shipping it.  It's a mess.
I'd hoped to leave myself a day the end to review my code, break it into
modules, author helpful comments throughout, ... and none of that
happened.  D:

One larger regret I have is how very-over-the-deadline my work on it ran.
As I submit it, it's not yet clear if the TO will include this in LEFTS1
or wait until LEFTS2.

On my end, even knowing I was a full week past the LEFTS1 deadline, I
wanted to finish it now, while it was still in my brain.  I didn't want
the spectre of this unfinished project hanging over me for a year.

In all, I'm happy with it, and hope you enjoy it.
I hope it causes you to learn something new about accessibility.
I hope you yearn.

quietly-turning  
18 December 2025
