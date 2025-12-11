#!/usr/bin/env python3
"""
Create LibreOffice Impress presentation for Palmer Penguins Part 1 video.
Generates an 8-slide ODP file with analysis images, titles, and minimal text.
"""

from odf.opendocument import OpenDocumentPresentation
from odf.style import Style, MasterPage, PageLayout, PageLayoutProperties
from odf.style import TextProperties, GraphicProperties, ParagraphProperties
from odf.style import DrawingPageProperties
from odf.draw import Page, Frame, Image, TextBox
from odf.text import P, Span
import os
import shutil

# Configuration
BASE_DIR = "/Users/zenn/Dropbox/prj/qblog/posts/palmer_penguins_part1"
OUTPUT_DIR = f"{BASE_DIR}/video_production/slides"
OUTPUT_FILE = f"{OUTPUT_DIR}/Palmer_Penguins_Part1_3min.odp"

# Slide dimensions (16:9 in cm, LibreOffice uses cm)
SLIDE_WIDTH = "28cm"
SLIDE_HEIGHT = "15.75cm"

# Colors - high contrast palette
COLORS = {
    "adelie": "#FF6B6B",      # Coral red
    "chinstrap": "#9B59B6",   # Purple (replaces teal)
    "gentoo": "#2E86AB",      # Deep ocean blue (replaces light blue)
    "text_dark": "#2C3E50",
    "white": "#FFFFFF",
    "accent": "#27AE60",      # Green for key text
}

# Slide content definition
SLIDES = [
    {
        "title": "Palmer Penguins Part 1",
        "subtitle": "Exploratory Data Analysis & Simple Regression",
        "image": "penguin-hero-part1.png",
        "key_text": "Can flipper length predict body mass?",
    },
    {
        "title": "The Data: 333 Penguins, 3 Species",
        "subtitle": "",
        "image": "eda-overview.png",
        "key_text": "Adelie | Chinstrap | Gentoo",
    },
    {
        "title": "Correlation: r = 0.87",
        "subtitle": "Strong relationship between flipper length and body mass",
        "image": "correlation-matrix.png",
        "key_text": "",
    },
    {
        "title": "Simple Linear Regression",
        "subtitle": "Body Mass = -5,781 + 49.7 × Flipper Length",
        "image": "simple-regression-model.png",
        "key_text": "R² = 0.762",
    },
    {
        "title": "Making Predictions",
        "subtitle": "200mm flipper → ~4,100g body mass",
        "image": "simple-regression-model.png",
        "key_text": "Every 1mm of flipper ≈ 50g of body mass",
    },
    {
        "title": "The Problem: Species Clustering",
        "subtitle": "Residuals reveal what the model misses",
        "image": "model-diagnostics.png",
        "key_text": "Species matters!",
    },
    {
        "title": "Key Takeaways",
        "subtitle": "",
        "image": "species-comparison.png",
        "key_text": "76% variance explained, but species differences remain",
    },
    {
        "title": "Next: Part 2",
        "subtitle": "Adding species to the model",
        "image": "penguin-hero-part1.png",
        "key_text": "R² jumps from 0.76 → 0.86+",
    },
]


def create_presentation():
    """Create the ODP presentation file."""
    doc = OpenDocumentPresentation()

    # Create page layout
    pagelayout = PageLayout(name="PL1")
    pagelayout.addElement(
        PageLayoutProperties(
            pagewidth=SLIDE_WIDTH,
            pageheight=SLIDE_HEIGHT,
            printorientation="landscape",
        )
    )
    doc.automaticstyles.addElement(pagelayout)

    # Create master page with white background
    masterpage = MasterPage(name="Default", pagelayoutname=pagelayout)
    doc.masterstyles.addElement(masterpage)

    # Create drawing page style (white background)
    dpstyle = Style(name="dp1", family="drawing-page")
    dpstyle.addElement(DrawingPageProperties(fill="solid", fillcolor="#ffffff"))
    doc.automaticstyles.addElement(dpstyle)

    # Create title style
    title_style = Style(name="title", family="presentation")
    title_style.addElement(
        TextProperties(
            fontsize="48pt",
            fontweight="bold",
            color=COLORS["text_dark"],
            fontfamily="Inter, Source Sans Pro, sans-serif",
        )
    )
    title_style.addElement(ParagraphProperties(textalign="left"))
    doc.automaticstyles.addElement(title_style)

    # Create subtitle style
    subtitle_style = Style(name="subtitle", family="presentation")
    subtitle_style.addElement(
        TextProperties(
            fontsize="28pt",
            color=COLORS["text_dark"],
            fontfamily="Inter, Source Sans Pro, sans-serif",
        )
    )
    subtitle_style.addElement(ParagraphProperties(textalign="left"))
    doc.automaticstyles.addElement(subtitle_style)

    # Create key text style (larger, colored)
    keytext_style = Style(name="keytext", family="presentation")
    keytext_style.addElement(
        TextProperties(
            fontsize="36pt",
            fontweight="bold",
            color=COLORS["accent"],
            fontfamily="Inter, Source Sans Pro, sans-serif",
        )
    )
    keytext_style.addElement(ParagraphProperties(textalign="center"))
    doc.automaticstyles.addElement(keytext_style)

    # Create frame styles
    frame_style = Style(name="fr1", family="graphic")
    frame_style.addElement(GraphicProperties(stroke="none", fill="none"))
    doc.automaticstyles.addElement(frame_style)

    # Create each slide
    for i, slide_content in enumerate(SLIDES):
        page = Page(stylename=dpstyle, masterpagename=masterpage)

        # Add title frame (top left)
        title_frame = Frame(
            stylename=frame_style,
            width="18cm",
            height="2cm",
            x="1cm",
            y="0.5cm",
        )
        textbox = TextBox()
        p = P(stylename=title_style)
        p.addText(slide_content["title"])
        textbox.addElement(p)
        title_frame.addElement(textbox)
        page.addElement(title_frame)

        # Add subtitle if present
        if slide_content["subtitle"]:
            subtitle_frame = Frame(
                stylename=frame_style,
                width="18cm",
                height="1.5cm",
                x="1cm",
                y="2.3cm",
            )
            textbox = TextBox()
            p = P(stylename=subtitle_style)
            p.addText(slide_content["subtitle"])
            textbox.addElement(p)
            subtitle_frame.addElement(textbox)
            page.addElement(subtitle_frame)

        # Add image frame (centered, takes most of slide)
        # Image positioned to fill ~2/3 of slide as per guide
        img_path = os.path.join(BASE_DIR, slide_content["image"])
        if os.path.exists(img_path):
            # Copy image to Pictures folder in ODP
            img_frame = Frame(
                stylename=frame_style,
                width="20cm",
                height="10cm",
                x="4cm",
                y="4cm",
            )
            # We'll add the image reference - actual embedding happens during save
            href = doc.addPicture(img_path)
            img_frame.addElement(Image(href=href))
            page.addElement(img_frame)

        # Add key text at bottom if present
        if slide_content["key_text"]:
            keytext_frame = Frame(
                stylename=frame_style,
                width="26cm",
                height="1.5cm",
                x="1cm",
                y="14cm",
            )
            textbox = TextBox()
            p = P(stylename=keytext_style)
            p.addText(slide_content["key_text"])
            textbox.addElement(p)
            keytext_frame.addElement(textbox)
            page.addElement(keytext_frame)

        doc.presentation.addElement(page)

    # Save the document
    doc.save(OUTPUT_FILE)
    print(f"Created: {OUTPUT_FILE}")
    return OUTPUT_FILE


if __name__ == "__main__":
    output = create_presentation()
    print(f"\nSlide deck created successfully!")
    print(f"Open with: /Applications/LibreOffice.app/Contents/MacOS/soffice --impress '{output}'")
