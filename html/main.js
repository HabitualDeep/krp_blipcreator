$(document).ready(function() {
    // Event listener for when the user submits the blip form
    $('#blipForm').submit(function(event) {
        event.preventDefault(); // Prevent default form submission

        // Get form values
        var blipName = $('#blipName').val();
        var blipType = $('#blipType').val();
        var blipColor = $('#blipColor').val();
        var blipCoords = $('#blipCoords').val().split(',');

        // Convert coordinates to numbers
        var blipX = parseFloat(blipCoords[0]);
        var blipY = parseFloat(blipCoords[1]);
        var blipZ = parseFloat(blipCoords[2]);

        // Send blip data to the server
        $.post('http://your-server-ip/createBlip', JSON.stringify({
            name: blipName,
            type: blipType,
            color: blipColor,
            x: blipX,
            y: blipY,
            z: blipZ
        }));

        // Clear form fields after submission
        $('#blipForm')[0].reset();
    });
});
