$('#myModal').on('hide.bs.modal', function () { //Change #myModal with your modal id
    $('audio').each(function(){
      this.pause(); // Stop playing
      this.currentTime = 0; // Reset time
    }); 
})