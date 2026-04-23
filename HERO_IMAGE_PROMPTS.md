# Hero Image Gemini Prompts

Prompts for [gemini.google.com](https://gemini.google.com) (Imagen 3).
Copy each prompt verbatim, download the result, then process:

```bash
magick ~/Downloads/Gemini_Generated_Image_XXXX.png \
  -resize 1600x -strip -quality 85 hero.jpg
```

Move `hero.jpg` into the post's `media/images/` directory.

Status key: DONE = generated and installed, KEEP = existing image is fine.

---

## Batch 1: Penguin / data series

### Post 08 -- Palmer Penguins Part 1: EDA [KEEP, RESIZE]

Existing penguin photo is appropriate. Resize only:

```bash
magick media/images/penguin-hero.jpg -resize 1920x -strip -quality 85 \
  media/images/penguin-hero.jpg
```

### Post 09 -- Palmer Penguins Part 2: Multiple Regression [DONE]

### Post 10 -- Palmer Penguins Part 3: Cross-Validation [DONE]

### Post 11 -- Palmer Penguins Part 4: Model Diagnostics [DONE]

### Post 12 -- Palmer Penguins Part 5: Random Forest [DONE]

### Post 13 -- Predictive Modeling of Penguin Body Mass [KEEP, RESIZE]

Same penguin photo as post 08. Resize only:

```bash
magick media/images/hero.jpg -resize 1920x -strip -quality 85 \
  media/images/hero.jpg
```

### Post 14 -- Penguins zzcollab [KEEP]

Different penguin photo, appropriate, already 226 KB.

---

## Batch 2: R coding / analysis

### Post 04 -- Set Names to Lowercase for Multiple Dataframes

```
Generate a 16:9 landscape image with the following description:

Editorial photograph of a wooden desk with scattered index
cards, each showing a single word in clean handwriting (text
intentionally blurred, illegible). Some cards face up, others
are being flipped over by an unseen hand. Warm natural light
from the left, shallow depth of field, muted cream and brown
palette. Metaphor: renaming and reorganising. Style: editorial
still life, 50mm lens, photographic realism, no people visible,
no logos, no readable text.
```

### Post 15 -- Piping in R

```
Generate a 16:9 landscape image with the following description:

Editorial photograph of a series of copper water pipes running
along a concrete wall in an industrial building, converging
from multiple sources into a single main pipe. Warm overhead
lighting creates highlights on the copper. Muted industrial
palette (copper, grey concrete, warm shadows). Metaphor: data
flowing through a pipeline. Style: architectural photography,
35mm lens, deep depth of field, photographic realism, no text,
no logos, no people.
```

### Post 16 -- Plots from purrr

```
Generate a 16:9 landscape image with the following description:

Editorial photograph of a sleeping white cat curled on a stack
of printed data visualisation charts on a wooden desk. The
charts show colourful scatter plots and bar charts (intentionally
soft-focus, no readable text). Warm afternoon light, shallow
depth of field on the cat. Muted warm palette. Metaphor: purrr
package (cat) producing multiple plots. Style: lifestyle
photography, 85mm lens, bokeh, photographic realism, no logos,
no people.
```

### Post 17 -- Rapid Conversion of R Scripts to Rmd

```
Generate a 16:9 landscape image with the following description:

Editorial photograph of two overlapping sheets of paper on a
dark desk, one plain white (representing .R), the other with a
subtle woven texture (representing .Rmd). A soft beam of light
illuminates the overlap where the two sheets meet. Minimal
composition, dark moody palette with a single warm highlight.
Style: editorial still life, macro lens, shallow depth of field,
photographic realism, no text, no logos, no people.
```

### Post 18 -- Updating an R Package

```
Generate a 16:9 landscape image with the following description:

Editorial photograph of a vintage toolbox sitting open on a
workbench, containing neatly organised wrenches and screwdrivers
of graduated sizes. One tool is laid out beside the box as if
just selected. Warm workshop lighting, wood and metal textures.
Metaphor: maintaining and updating a toolset. Style: editorial
still life, 50mm lens, shallow depth of field, photographic
realism, no text, no logos, no people.
```

### Post 19 -- Clinical Trial Data Validation Across Languages

```
Generate a 16:9 landscape image with the following description:

Editorial photograph of a laboratory notebook open on a clean
white bench, with a ruler and pencil laid precisely alongside.
A small stack of printed tables (blurred, no readable text) sits
to the right. Cool clinical lighting, high-key palette (whites,
light greys, steel blue accents). Metaphor: precision and
validation. Style: scientific photography, 50mm lens, deep depth
of field, photographic realism, no text, no logos, no people.
```

### Post 35 -- Writing a Simple R Package Using S3 Methods

```
Generate a 16:9 landscape image with the following description:

Editorial photograph of a set of Russian nesting dolls (matryoshka)
arranged in a line from largest to smallest on a wooden shelf.
Each doll is a slightly different shade of blue. Soft diffused
light, warm wood background, minimal composition. Metaphor:
object-oriented dispatch (nested structures). Style: editorial
still life, 85mm lens, shallow depth of field, photographic
realism, no text, no logos, no people.
```

### Post 38 -- Controlling Table Placement in R Markdown

```
Generate a 16:9 landscape image with the following description:

Editorial photograph of a typesetter's wooden tray (compositor's
case) with small lead letterpress blocks arranged in neat rows.
Some blocks are being rearranged by hand (hand blurred in
motion). Warm workshop lighting, rich wood tones, metallic
letter surfaces. Metaphor: precise placement and layout. Style:
editorial craft photography, macro lens, shallow depth of field,
photographic realism, no readable text, no logos.
```

### Post 40 -- Testing Data Analysis Workflows in R

```
Generate a 16:9 landscape image with the following description:

Editorial photograph of a row of laboratory test tubes in a
metal rack, each filled with a different shade of blue liquid,
arranged in a gradient from light to dark. Clean white background,
clinical lighting, precise alignment. Metaphor: systematic
testing across a range. Style: scientific still life, 100mm
macro lens, deep depth of field, photographic realism, no text,
no logos, no people.
```

### Post 43 -- Dynamic Column Names in R

```
Generate a 16:9 landscape image with the following description:

Editorial photograph of a Rubik's cube mid-solve on a dark
wooden surface, with one face nearly complete and the others
showing mixed colours. Single overhead spotlight creates a
dramatic shadow. Dark moody palette with the cube's colours as
the only saturation. Metaphor: rearranging and aligning named
elements. Style: editorial product photography, 85mm lens,
shallow depth of field, photographic realism, no text, no logos,
no people.
```

---

## Batch 3: Setup / tooling

### Post 01 -- Configure the Command Line for Data Science

```
Generate a 16:9 landscape image with the following description:

Editorial photograph of a dark terminal window reflected in
the surface of a polished wooden desk. The terminal shows
several lines of coloured prompt text (intentionally blurred,
no readable characters). A subtle warm glow from the screen
illuminates the desk surface. Dark moody palette with green
and amber terminal-colour accents. Style: editorial technology
photography, 50mm lens, shallow depth of field, photographic
realism, no text, no logos, no people.
```

### Post 03 -- Install Linux Mint on a MacBook Air

```
Generate a 16:9 landscape image with the following description:

Editorial photograph of a thin silver laptop (generic, no
visible logo) sitting open on a white desk. The screen displays
a green-tinted desktop environment (blurred, no readable text
or icons). A USB flash drive sits beside the laptop. Clean
minimal composition, bright even lighting, white and silver
palette with green accent from the screen. Style: product
photography, 35mm lens, deep depth of field, photographic
realism, no text, no logos, no people.
```

### Post 05 -- The ls --since Utility

```
Generate a 16:9 landscape image with the following description:

Editorial photograph of a wall-mounted vintage clock next to
a row of manila file folders standing upright on a wooden shelf.
The clock shows late afternoon. Warm side lighting casts long
shadows from the folders across the shelf. Muted warm palette
(cream, brown, brass). Metaphor: listing files by time. Style:
editorial still life, 50mm lens, shallow depth of field,
photographic realism, no text, no logos, no people.
```

### Post 07 -- Setting Up Multi-Language Quarto Documents

```
Generate a 16:9 landscape image with the following description:

Editorial photograph of three open notebooks stacked at slight
angles on a desk, each showing text in a different script or
writing system (all intentionally blurred, illegible). A single
pen bridges across all three notebooks. Warm natural light,
earth-tone palette. Metaphor: multiple languages converging
in one document. Style: editorial still life, 50mm lens,
shallow depth of field, photographic realism, no readable text,
no logos, no people.
```

### Post 23 -- Setting Up AWS EC2 Console

```
Generate a 16:9 landscape image with the following description:

Editorial photograph of a laptop screen showing a web dashboard
with blue and orange panels (intentionally blurred, no readable
text or logos). The laptop sits on a clean white desk. A
smartphone lies beside it showing a notification (also blurred).
Cool blue palette with warm orange accent. Style: editorial
technology photography, 35mm lens, shallow depth of field,
photographic realism, no text, no recognisable logos, no people.
```

### Post 25 -- Setting Up Git for Data Science

```
Generate a 16:9 landscape image with the following description:

Editorial photograph of a tree with multiple branches diverging
from a single trunk, shot from directly below looking up into
the canopy. The branches form a natural network pattern against
a bright overcast sky. Muted green and grey palette, soft
diffused light. Metaphor: branching version control. Style:
nature photography, wide-angle lens, deep depth of field,
photographic realism, no text, no logos, no people.
```

### Post 26 -- Setting Up Neovim as a Data Science IDE

```
Generate a 16:9 landscape image with the following description:

Editorial photograph of a mechanical keyboard on a dark desk,
with the keys softly backlit in green. A single monitor behind
it shows lines of coloured code (intentionally blurred, no
readable text). Dark moody palette with green and amber accents.
Shallow depth of field focused on the keyboard. Style: editorial
technology photography, 50mm lens, photographic realism, no
text, no recognisable logos, no people.
```

### Post 27 -- Setting Up OBS for Webcasting

```
Generate a 16:9 landscape image with the following description:

Editorial photograph of a small home recording studio setup:
a microphone on a boom arm, a ring light (turned off), and a
laptop (screen dark) arranged on a desk. Moody low-key lighting
from a single desk lamp. Dark palette with warm amber from the
lamp. Metaphor: preparing to broadcast. Style: editorial
lifestyle photography, 35mm lens, shallow depth of field,
photographic realism, no text, no logos, no people.
```

### Post 28 -- Setting Up rrtools R Data Analysis Project

```
Generate a 16:9 landscape image with the following description:

Editorial photograph of an architect's drafting table with a
rolled blueprint partially unrolled, a compass, and a T-square
laid out precisely. Warm overhead task lighting, wood and brass
textures. Metaphor: structured project scaffolding. Style:
editorial craft photography, 50mm lens, shallow depth of field,
photographic realism, no readable text, no logos, no people.
```

### Post 29 -- Reproducible Blog Posts with ZZCOLLAB

```
Generate a 16:9 landscape image with the following description:

Editorial photograph of a printing press with freshly printed
sheets stacked neatly beside it. The press mechanism is visible
in the background (slightly out of focus). Warm industrial
lighting, rich ink-black and cream palette. Metaphor:
reproducible publishing. Style: editorial industrial
photography, 35mm lens, shallow depth of field, photographic
realism, no readable text, no logos, no people.
```

### Post 30 -- Setting Up R, Vimtex, and UltiSnips in Vim

```
Generate a 16:9 landscape image with the following description:

Editorial photograph of three precision tools laid in a row on
a dark felt surface: a fountain pen, a mechanical pencil, and
a fine brush. Each tool is slightly different in material
(brass, silver, wood). Soft overhead lighting, dark background,
metallic highlights. Metaphor: three complementary editing tools.
Style: editorial product photography, macro lens, shallow depth
of field, photographic realism, no text, no logos, no people.
```

### Post 31 -- Configuring Yabai as a Tiling Window Manager

```
Generate a 16:9 landscape image with the following description:

Editorial photograph, overhead view of a mosaic tile floor
being laid. Square and rectangular ceramic tiles in muted earth
tones (cream, terracotta, slate) are arranged in a precise grid
pattern with thin grout lines. Some tiles at the edge are not
yet placed. Soft natural light, warm palette. Metaphor: tiling
window arrangement. Style: architectural detail photography,
overhead shot, deep depth of field, photographic realism, no
text, no logos, no people.
```

### Post 37 -- Writing a Vim Plugin for REPL

```
Generate a 16:9 landscape image with the following description:

Editorial photograph of a vintage telegraph key (Morse code
transmitter) on a wooden desk, with a coiled copper wire leading
off-frame. Warm workshop lighting, brass and wood textures. A
small notepad with hand-drawn diagrams sits beside it (blurred,
illegible). Metaphor: sending commands from one place to another
(REPL). Style: editorial still life, macro lens, shallow depth
of field, photographic realism, no readable text, no logos,
no people.
```

### Post 41 -- Embedding Python Code in UltiSnips Snippets

```
Generate a 16:9 landscape image with the following description:

Editorial photograph of a set of metal cookie cutters in
various geometric shapes (stars, circles, rectangles) arranged
on a flour-dusted marble countertop. One cutter has just stamped
a shape into rolled dough. Soft overhead lighting, white and
silver palette with warm dough tones. Metaphor: snippets as
reusable templates that stamp out patterns. Style: editorial
food photography, 50mm lens, shallow depth of field,
photographic realism, no text, no logos, no people.
```

### Post 48 -- A Pocket Terminal with ttyd

```
Generate a 16:9 landscape image with the following description:

Editorial photograph of a small vintage portable radio sitting
on a windowsill, antenna extended. Through the window behind
it, a blurred cityscape is visible at dusk. Warm amber light
from inside, cool blue light from outside. Metaphor: a portable
device that connects you to something larger. Style: editorial
lifestyle photography, 50mm lens, shallow depth of field,
photographic realism, no text, no logos, no people.
```

---

## Batch 4: Docker / reproducibility / Shiny

### Post 02 -- Archiving 400 GitHub Repos Locally

```
Generate a 16:9 landscape image with the following description:

Editorial photograph of a long row of leather-bound books on
a library shelf, shot at eye level with a shallow depth of
field so the books recede into soft blur. The spines show no
readable text. Warm library lighting, rich brown and gold
palette. Metaphor: archiving a large collection. Style:
editorial interior photography, 85mm lens, bokeh, photographic
realism, no readable text, no logos, no people.
```

### Post 06 -- From Markdown to Blog Post: ZZCOLLAB

```
Generate a 16:9 landscape image with the following description:

Editorial photograph of a manual typewriter with a sheet of
paper loaded, showing a few lines of typed text (intentionally
blurred, illegible). The typewriter sits on a wooden desk next
to a closed laptop. Warm side lighting creates contrast between
old and new. Earth-tone palette. Metaphor: transforming raw
text into a polished publication. Style: editorial still life,
50mm lens, shallow depth of field, photographic realism, no
readable text, no logos, no people.
```

### Post 32 -- Sharing R Markdown Code Reproducibly with Docker

```
Generate a 16:9 landscape image with the following description:

Editorial photograph of a stack of identical cardboard shipping
boxes on a loading dock, each sealed and labelled with a
coloured sticker (no readable text). Industrial concrete floor,
metal roll-up door partially open in the background. Cool
overcast light from outside, warm interior lighting. Metaphor:
packaging code into reproducible containers. Style: editorial
industrial photography, 35mm lens, deep depth of field,
photographic realism, no readable text, no logos, no people.
```

### Post 34 -- Combining Observable JS and Shiny

```
Generate a 16:9 landscape image with the following description:

Editorial photograph of two gears interlocking, one brass and
one steel, viewed from the side. The gears are mounted on a
dark wooden base. Soft directional lighting highlights the
teeth where the gears mesh. Dark palette with metallic
highlights. Metaphor: two systems working together. Style:
editorial macro photography, 100mm lens, shallow depth of
field, photographic realism, no text, no logos, no people.
```

### Post 36 -- Prototyping a Shiny App with ChatGPT

```
Generate a 16:9 landscape image with the following description:

Editorial photograph of a sketchbook open to a page showing
wireframe UI drawings (boxes, buttons, arrows, all intentionally
loose and hand-drawn, no readable text). A pencil and an eraser
sit on the page. The sketchbook is on a light wooden desk with
soft natural light. Clean, bright palette. Metaphor: rapid
prototyping by sketching before building. Style: editorial
lifestyle photography, 50mm lens, shallow depth of field,
photographic realism, no readable text, no logos, no people.
```

### Post 39 -- Template Post [REPLACE penguin with generic template image]

```
Generate a 16:9 landscape image with the following description:

Editorial photograph of a blank architect's grid paper on a
drafting table, with a mechanical pencil and a small metal
ruler. The grid lines are faintly visible. Clean, minimal,
bright composition with lots of white space. Light grey and
silver palette with warm wood at the edges. Metaphor: a blank
template ready to be filled. Style: editorial minimalist
photography, overhead shot, deep depth of field, photographic
realism, no text, no logos, no people.
```

### Post 42 -- Running ZZedc Independently for Clinical

```
Generate a 16:9 landscape image with the following description:

Editorial photograph of a single laboratory pipette dispensing
a drop of blue liquid into a clear glass vial, held in a metal
rack. Clean white bench, clinical lighting, high-key palette
(whites, light blues, stainless steel). Metaphor: isolating
and running a single component independently. Style: scientific
photography, macro lens, shallow depth of field, photographic
realism, no text, no logos, no people.
```

---

## Processing checklist

After downloading each image from Gemini:

```bash
cd posts/<NN-name>/<name>/media/images/
mv ~/Downloads/Gemini_Generated_Image_XXXX.png hero-raw.png
magick hero-raw.png -resize 1600x -strip -quality 85 hero.jpg
rm hero-raw.png
```

Update `media/images/README.md`:

```
hero.jpg -- Generated with Google Imagen 3 via Gemini, YYYY-MM-DD.
  Prompt: '[paste full prompt]'
```

## Progress tracker

| # | Title (short) | Status |
|---|---|---|
| 01 | Command Line Config | TODO |
| 02 | GitHub Archive | TODO |
| 03 | Linux Mint Install | TODO |
| 04 | Lowercase Dataframes | TODO |
| 05 | ls --since | TODO |
| 06 | Markdown to Blog | TODO |
| 07 | Multi-Language Quarto | TODO |
| 08 | Penguins EDA | RESIZE |
| 09 | Penguins Regression | DONE |
| 10 | Penguins Cross-Val | DONE |
| 11 | Penguins Diagnostics | DONE |
| 12 | Penguins Random Forest | DONE |
| 13 | Penguins Body Mass | RESIZE |
| 14 | Penguins zzcollab | KEEP |
| 15 | Piping in R | TODO |
| 16 | Plots from purrr | TODO |
| 17 | R to Rmd Conversion | TODO |
| 18 | R Package Updating | TODO |
| 19 | Clinical Trial Validation | TODO |
| 20 | Research Backup | KEEP |
| 21 | Research Management | KEEP |
| 22 | AWS CLI Setup | KEEP |
| 23 | AWS Console Setup | TODO |
| 24 | GitHub Dotfiles | KEEP |
| 25 | Git Setup | TODO |
| 26 | Neovim Setup | DONE |
| 27 | OBS Setup | TODO |
| 28 | rrtools Setup | DONE |
| 29 | ZZCOLLAB Blog Posts | DONE |
| 30 | R Vimtex UltiSnips | DONE |
| 31 | Yabai Tiling WM | TODO |
| 32 | Docker R Markdown | TODO |
| 33 | Docker Shiny | KEEP |
| 34 | Observable + Shiny | TODO |
| 35 | S3 Methods Package | TODO |
| 36 | Shiny + ChatGPT | TODO |
| 37 | Vim Plugin REPL | DONE |
| 38 | Table Placement Rmd | TODO |
| 39 | Template Post | TODO |
| 40 | Testing Workflows | TODO |
| 41 | UltiSnips Python | DONE |
| 42 | ZZedc Clinical | TODO |
| 43 | Dynamic Column Names | TODO |
| 47 | Setup Template | KEEP |
| 48 | ttyd Terminal | TODO |
