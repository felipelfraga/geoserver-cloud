module.exports.handler = async (event) => {
    console.log('Event: ', event);
    let responseMessage = 'SG Terraform Lambda Deployed!';

    const fs = require('fs');
    const crypto = require('crypto');


    let uuid = crypto.randomBytes(20).toString('hex');
    // writeFile function with filename, content and callback function
    fs.writeFile("/mnt/shapefiles/" + uuid + '.txt', 'lambda', function (err) {
      if (err) throw err;
      console.log('File is created successfully.');
    });


    fs.readdir("/mnt/shapefiles", function (err, files) {
      //handling error
      if (err) {
          return console.log('Unable to scan directory: ' + err);
      }
      //listing all files using forEach
      files.forEach(function (file) {
          // Do whatever you want to do with the file
          console.log(file);
      });

  });



    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        message: uuid,
      }),
    }
  }
