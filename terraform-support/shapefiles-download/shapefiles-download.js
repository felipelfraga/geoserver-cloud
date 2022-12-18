module.exports.handler = async (event) => {
    console.log('Event: ', event);

    const fs = require('fs');
    const decompress = require("decompress");

    const listFiles = (dir) => {
      fs.readdir(dir, function (err, files) {
        if (err) {
            return console.log('Erro ao listar o diretório: ' + err);
        }
        files.forEach(function (file) {
            console.log(file);
        });
      });
    }

    const download = async (url, dest, cb) => {

        const http = require('http');
        const file = fs.createWriteStream(dest);

        const request = http.get(url, (response) => {
            // check if response is success
            if (response.statusCode !== 200) {
                return cb('Response status was ' + response.statusCode);
            }

            response.pipe(file);
        });

        // close() is async, call cb after close completes
        file.on('finish', () => file.close(cb));

        // check for request error too
        request.on('error', (err) => {
            fs.unlink(dest, () => cb(err.message)); // delete the (partial) file and then return the error
        });

        file.on('error', (err) => { // Handle errors
            fs.unlink(dest, () => cb(err.message)); // delete the (partial) file and then return the error
        });
    };

    const BASE_PATH = "/mnt/shapefiles";
    const DETER_URL = "http://terrabrasilis.dpi.inpe.br/file-delivery/download/deter-amz/shape";
    const DETER_BASE_PATH = `${BASE_PATH}/deter`;
    const DETER_ZIPPED_PATH = `${DETER_BASE_PATH}/deter_public.zip`;

    console.log(DETER_BASE_PATH);
    if (!fs.existsSync(DETER_BASE_PATH)) {
      console.log(`Criando ${DETER_BASE_PATH}`)
      fs.mkdirSync(DETER_BASE_PATH);
    }

    if (!fs.existsSync(`${BASE_PATH}/deter/deter_public.shp`)) {
      console.log("Shapefile não existe. Iniciando download.")
      await download(DETER_URL, DETER_ZIPPED_PATH, (res) => {
        if (res) {
          console.log(res);
        }
        decompress(DETER_ZIPPED_PATH, DETER_BASE_PATH)
        .then((files) => {
          console.log(files);
          listFiles(DETER_BASE_PATH);
          fs.unlink(DETER_ZIPPED_PATH, () => {});
        })
        .catch((error) => {
          console.log(error);
          fs.unlink(DETER_ZIPPED_PATH, () => {});
        });
      });

    }

    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        message: "ok",
      }),
    }

};
