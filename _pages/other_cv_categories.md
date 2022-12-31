## <i class="fas fa-bullhorn"></i> Presentations

### <i class="fas fa-hand-sparkles"></i> Invited talks

{% assign invited_talks = site.data.bib.talks | where: "type", "invited" %}

{% for pub in invited_talks %}

{% capture title %}
{% if pub.title.url %}[{{pub.title.text}}]({{pub.title.url}})
{% else %}{{pub.title}}
{% endif %}
{% endcapture %}

{% capture author_line %}
{% for author in pub.authors %}
{% if forloop.first %} {{author}}
{% elsif forloop.last %}, & {{author}}
{% else %}, {{author}}
{% endif %}
{% endfor %}
{% endcapture %}

{% capture doi %}{% if pub.doi %} [{{pub.doi}}](http://doi.org/{{pub.doi}}).{% endif %}{% endcapture %}

{% capture bonus %}
{% if pub.bonus %}
[{{pub.bonus.text}}]
{% endif %}
{% endcapture %}


{{ author_line | strip_newlines }} ({{ pub.when.year }}, {{ pub.when.month }}). **{{ title  | strip_newlines }}**. {{ pub.where  | strip_newlines }} {{doi}} {{ bonus  | strip_newlines }}
{% endfor %}




### <i class="fas fa-microphone"></i> Conference talks

{% assign authored_talks = site.data.bib.talks | where: "type", "authored" %}

{% for pub in authored_talks %}

{% capture title %}
{% if pub.title.url %}[{{pub.title.text}}]({{pub.title.url}})
{% else %}{{pub.title}}
{% endif %}
{% endcapture %}

{% capture author_line %}
{% for author in pub.authors %}
{% if forloop.first %} {{author}}
{% elsif forloop.last %}, & {{author}}
{% else %}, {{author}}
{% endif %}
{% endfor %}
{% endcapture %}

{% capture doi %}{% if pub.doi %} [{{pub.doi}}](http://doi.org/{{pub.doi}}).{% endif %}{% endcapture %}
{% capture bonus %}
{% if pub.bonus %}
[{{pub.bonus.text}}]
{% endif %}
{% endcapture %}

{{ author_line | strip_newlines }} ({{ pub.when.year }}, {{ pub.when.month }}). **{{ title  | strip_newlines }}**. {{ pub.where  | strip_newlines }} {{doi}} {{ bonus | strip_newlines }}
{% endfor %}


### <i class="fas fa-people-carry"></i> Coauthored talks (i.e., I didn't talk, but probably did stats and made figures)

{% assign coauthored_talks = site.data.bib.talks | where: "type", "coauthored" %}

{% for pub in coauthored_talks %}

{% capture author_line %}
{% for author in pub.authors %}
{% if forloop.first %} {{author}}
{% elsif forloop.last %}, & {{author}}
{% else %}, {{author}}
{% endif %}
{% endfor %}
{% endcapture %}

{% capture doi %}{% if pub.doi %} [{{pub.doi}}](http://doi.org/{{pub.doi}}).{% endif %}{% endcapture %}
{% capture bonus %}
{% if pub.bonus %}
[{{pub.bonus.text}}]
{% endif %}
{% endcapture %}

{{ author_line | strip_newlines }} ({{ pub.when.year }}, {{ pub.when.month }}). **{{ pub.title  | strip_newlines }}**. {{ pub.where  | strip_newlines }} {{doi}} {{ bonus  | strip_newlines }}
{% endfor %}



### <i class="fas fa-image"></i> Posters

{% for pub in site.data.bib.posters %}

{% capture author_line %}
{% for author in pub.authors %}
{% if forloop.first %} {{author}}
{% elsif forloop.last %}, & {{author}}
{% else %}, {{author}}
{% endif %}
{% endfor %}
{% endcapture %}

{% capture doi %}{% if pub.doi %} [{{pub.doi}}](http://doi.org/{{pub.doi}}).{% endif %}{% endcapture %}
{% capture bonus %}
{% if pub.bonus %}
[{{pub.bonus.text}}]
{% endif %}
{% endcapture %}

{{ author_line | strip_newlines }} ({{ pub.when.year }}, {{ pub.when.month }}). **{{ pub.title  | strip_newlines }}**. {{ pub.where  | strip_newlines }} {{doi}} {{ bonus  | strip_newlines }}
{% endfor %}


## <i class="fas fa-chalkboard-teacher"></i> Teaching

### Lecturing



### Clinical experience



## <i class="fas fa-award"></i> Awards
