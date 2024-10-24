Multi-View Learning for Biological Spectral Unmixing Code and Data

Data Location:
The data used in this project is available for download at the following link:
https://doi.org/10.5281/zenodo.13988378

Setup Instructions:

Download the code:
Place all the code files in a folder, for example, a folder named multiview.

Download the data:
Download the dataset and place it in a folder named data inside the multiview folder. The folder structure should look like this:
multiview/
├── data/ (downloaded data goes here)
└── *.m (code files)

Description:

Data:

Multi-view reference images:
Images of 13 labeled E. coli cells captured using multiple views and mixed biological images.
Code (.m files):

demo.m – A demonstration script that showcases multi-view spectral unmixing on the provided data.
DisplayA.m – A function for visualizing or displaying abundance maps.
find_max_nonzero_submatrix.m – A function to find the largest non-zero submatrix in an image.
NLS.m – Implements Non-negative Least Squares for spectral unmixing.
NMF.m – Performs Non-negative Matrix Factorization for extracting endmembers.
removeBackground.m – Removes background noise from an image for cleaner analysis.


MIT License

Copyright (c) 2024 Ruogu Wang

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
