
import Foundation

struct StubArticleJSON {
    static let wrong =
    """
        "results": [
            {
            "uri": "nyt://article/f7611a05-caaf-51b8-915a-52f80ef7896d",
            "url": "https://www.nytimes.com/2021/10/25/opinion/leaf-blowers-california-emissions.html",
            "id": 100000008032465,
            "asset_id": 100000008032465,
            "source": "New York Times",
            "published_date": "2021-10-25",
            ]
    """
    
    static let correct =
    """
    {
      "status": "OK",
      "copyright": "Copyright (c) 2021 The New York Times Company.  All Rights Reserved.",
      "num_results": 20,
      "results": [
        {
          "uri": "nyt://article/f7611a05-caaf-51b8-915a-52f80ef7896d",
          "url": "https://www.nytimes.com/2021/10/25/opinion/leaf-blowers-california-emissions.html",
          "id": 100000008032465,
          "asset_id": 100000008032465,
          "source": "New York Times",
          "published_date": "2021-10-25",
          "updated": "2021-10-26 16:42:54",
          "section": "Opinion",
          "subsection": "",
          "nytdsection": "opinion",
          "adx_keywords": "Greenhouse Gas Emissions;Lawns;Hazardous and Toxic Substances;Gardens and Gardening;Air Pollution;Noise;Engines;Machinery and    Equipment",
          "column": null,
          "byline": "By Margaret Renkl",
          "type": "Article",
          "title": "The First Thing We Do, Let’s Kill All the Leaf Blowers",
          "abstract": "Nearly everything about how Americans “care” for their lawns is deadly, but these machines exist in a category of environmental hell all     their own.",
          "des_facet": [
            "Greenhouse Gas Emissions",
            "Lawns",
            "Hazardous and Toxic Substances",
            "Gardens and Gardening",
            "Air Pollution",
            "Noise",
            "Engines",
            "Machinery and Equipment"
          ],
          "org_facet": [],
          "per_facet": [],
          "geo_facet": [],
          "media": [
            {
              "type": "image",
              "subtype": "photo",
              "caption": "",
              "copyright": "Tom Williams/Roll Call/Getty Images",
              "approved_for_syndication": 1,
              "media-metadata": [
                {
                  "url": "https://static01.nyt.com/images/2021/10/25/opinion/25renkl-image/25renkl-image-thumbStandard-v2.jpg",
                  "format": "Standard Thumbnail",
                  "height": 75,
                  "width": 75
                },
                {
                  "url": "https://static01.nyt.com/images/2021/10/25/opinion/25renkl-image/25renkl-image-mediumThreeByTwo210-v2.jpg",
                  "format": "mediumThreeByTwo210",
                  "height": 140,
                  "width": 210
                },
                {
                  "url": "https://static01.nyt.com/images/2021/10/25/opinion/25renkl-image/25renkl-image-mediumThreeByTwo440-v2.jpg",
                  "format": "mediumThreeByTwo440",
                  "height": 293,
                  "width": 440
                }
              ]
            }
          ],
          "eta_id": 0
        }
    ]
    }
    """
    
    static let correctCustom =
    """
    {
    "results": [
       {
          "thumbnail":"https://static01.nyt.com/images/2021/10/31/business/31GenZ-illo/31GenZ-illo-thumbStandard-v2.jpg",
          "byline":"By Emma Goldberg",
          "id":100000008034228,
          "title":"The 37-Year-Olds Are Afraid of the 23-Year-Olds Who Work for Them",
          "image":"https://static01.nyt.com/images/2021/10/31/business/31GenZ-illo/31GenZ-illo-mediumThreeByTwo440-v2.jpg",
          "abstract":"Twenty-somethings rolling their eyes at the habits of their elders is a longstanding trend, but many employers said there’s a new boldness in the way Gen Z dictates taste.",
          "publishedDate":657061200,
          "url":"https://www.nytimes.com/2021/10/28/business/gen-z-workplace-culture.html"
       },
       {
          "thumbnail":"https://static01.nyt.com/images/2021/10/28/business/28facebook-park/28facebook-park-thumbStandard.jpg",
          "byline":"By Mike Isaac",
          "id":100000008047086,
          "title":"Facebook Renames Itself Meta",
          "image":"https://static01.nyt.com/images/2021/10/28/business/28facebook-park/28facebook-park-mediumThreeByTwo440.jpg",
          "abstract":"The social network, under fire for spreading misinformation and other issues, said the change was part of its bet on a next digital frontier called the metaverse.",
          "publishedDate":657061200,
          "url":"https://www.nytimes.com/2021/10/28/technology/facebook-meta-name-change.html"
       }
    ]
    }
    """
}
