# Project 6 - *TranslateMe*

Submitted by: **Trina Tabassum**

**TranslateMe** is an iOS translation application built using SwiftUI, the MyMemory Translation API, and Cloud Firestore. It enables users to translate text across multiple languages, preserves translation records persistently in real-time, and provides interactive history management tools.

Time spent: **3** hours spent in total

## Required Features

The following **required** functionality is completed:

- [x] Users open the app to a TranslationMe home page with a place to enter a word, phrase or sentence, a button to translate, and another field that should initially be empty
- [x] When users tap translate, the word written in the upper field translates in the lower field. The requirement is only that you can translate from one language to another.
- [x] A history of translations can be stored (in a scroll view in the same screen, or a new screen)
- [x] The history of translations can be erased
 
The following **optional** features are implemented:

- [x] Add a variety of choices for the languages (Segmented picker supporting Spanish, French, German, and Italian)
- [x] Add UI flair (Real-time "Translating..." button feedback, custom boxed framing with accent strokes, copy-to-clipboard action with popup confirmation, and an action sheet confirmation modal before clearing all history)

The following **additional** features are implemented:

- [x] Swipe-to-delete gesture to delete individual translation items from Cloud Firestore without clearing the entire history
- [x] Client-side fast translation cache for instantaneous responses on frequent expressions

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<https://tinyurl.com/3scmp7s4>

## Notes

Handling asynchronous network calls with public API rate limiting required implementing both proper Swift concurrency (`async/await`) and a fallback cache. Additionally, structuring Firestore snapshot listeners ensured real-time UI synchronizations across screen navigations.

## License

    Copyright 2026 Trina Tabassum

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
