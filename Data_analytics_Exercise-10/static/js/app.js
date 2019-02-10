//Data import
var tableData = data;

// Select the submit button
var filter = d3.select("#filter-btn");

// generates the dropdown of available shapes
var select = document.getElementById("shape");
var options = [...new Set(tableData.map(x => x.shape))];

for(var i = 0; i < options.length; i++) {
    var opt = options[i];
    var el = document.createElement("option");
    el.textContent = opt;
    el.value = opt;
    select.appendChild(el);
};

//function to check if object is empty
function isEmpty(obj) {
    for(var key in obj) {
        if(obj.hasOwnProperty(key))
            return false;
    }
    return true;
};



filter.on("click", function() {

    // Prevents the page from refreshing
    d3.event.preventDefault();

    //clears any existing table
    var tbody = d3.select("tbody");
    tbody.selectAll('tr').remove();
    tbody.selectAll('td').remove();

    // Select the input elements
    var dateInput = d3.select("#datetime");
    var shapeInput = d3.select("#shape");
  
    // Get the value property of the input elements
    var dateInputValue = dateInput.property("value");
    var shapeInputValue = shapeInput.property("value");

    //Logging entered data
    //console.log(dateInputValue);
    //console.log(shapeInputValue);

   //Event handler for empty date field
   if (isEmpty(dateInputValue)) {
       window.alert("Please enter a valid date")
   } else {
            //create filtered data
            var filteredData = tableData.filter(data => data.datetime == dateInputValue);

            //Event handler for invalid dates
            if (isEmpty(filteredData)) {
                window.alert("Data not found!");
                
            //Event handler for valid dates
            } else {
                //final data modifier based on whether a shape filter is provided
                if (shapeInputValue == "Select a shape (optional)") {
                    var finalFilteredData = filteredData
                } else {
                    var finalFilteredData = filteredData.filter(data => data.shape == shapeInputValue)
                }
                
                if (isEmpty(finalFilteredData)) {
                    window.alert("Sorry, there aren't any shapes reported for that date. Please try another shape");
                } else {
                    finalFilteredData.forEach((data) => {
                        var row = tbody.append("tr");
                        Object.entries(data).forEach(([key, value]) => {
                        var cell = tbody.append("td");
                        cell.text(value);
                        })});
                }
            };
        };

});