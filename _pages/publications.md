---
layout: archive
title: "Selected Publications"
permalink: /publications/
author_profile: true
---

Click on the title of each listed publication for more information.

{% if author.googlescholar %}
  You can also find my articles on <u><a href="{{author.googlescholar}}">my Google Scholar profile</a>.</u>
{% endif %}

{% include base_path %}

{% for post in site.publications reversed %}
  {% include archive-single.html %}
{% endfor %}




Other Publications
===
For a complete list of my publications visit [PubMed](https://pubmed.ncbi.nlm.nih.gov/?term=Bedwell+GJ+NOT+South+Africa&sort=date)
