function UserSentiments(data) {
  var labels = data.map(function(entry) {
    return entry.username;
  });

  var margin = {
      top: 20,
      right: 30,
      bottom: 130,
      left: 40
    },
    width = 1000 - margin.left - margin.right,
    height = 460 - margin.top - margin.bottom;


  var x = d3.scale.ordinal().rangeRoundBands([0, width], .05),
    y = d3.scale.linear().range([height, 0]);

  var xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom");

  var yAxis = d3.svg.axis()
    .scale(y)
    .orient("left")
    .ticks(10);

  var svg = d3.select("#user_sentiments").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  x.domain(labels);
  y.domain([0, d3.max(data, function(d) {
    return (+d.positive + d.negative + d.nothing);
  })]);
  svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis)
    .selectAll("text")
    .attr("transform", "translate(-15,10), rotate(-75)") //TODO prüfen ob namen unter richtiger spalte stehen
    .style("text-anchor", "end");

  svg.append("g")
    .attr("class", "y axis")
    .call(yAxis)
    .append("text")
    .attr("transform", "rotate(-90)")
    .attr("y", 6)
    .attr("dy", ".71em");

  //ab hier balken zeichnen
  var bar = svg.selectAll("bar")
    .data(data)
    .enter().append("g");
    // .attr("class", "bar");

  // positive
  bar.append("rect")
    .attr("class", "positive-bar")
    .attr("x", function(d) {
      return x(d.username);
    })
    .attr("width", x.rangeBand())
    .attr("y", function(d) {
      return y(+d.positive);
    })
    .attr("height", function(d) {
      return height - y(+d.positive);
    });

  // negative
  bar.append("rect")
    .attr("class", "negative-bar")
    .attr("x", function(d) {
      return x(d.username);
    })
    .attr("width", x.rangeBand())
    .attr("y", function(d) {
      return y(+d.positive + d.negative);
    })
    .attr("height", function(d) {
      return height - y(+d.negative);
    });

  // nothing
  bar.append("rect")
    .attr("class", "nothing-bar")
    .attr("x", function(d) {
      return x(d.username);
    })
    .attr("width", x.rangeBand())
    .attr("y", function(d) {
      return y(+d.positive + d.negative+d.nothing);
    })
    .attr("height", function(d) {
      return height - y(+d.nothing);
    });
}
