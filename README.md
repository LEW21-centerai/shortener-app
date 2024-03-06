# shortener-app

First, launch [shortener-api](https://github.com/LEW21-centerai/shortener-api) on http://localhost:8000/.

Then build and launch the app:

```sh
docker build -t app . && docker run -it -e API_SERVER=http://localhost:8000/ -p 1234:80 app
```

Then visit http://localhost:1234/

## Development
You can also use Parcel development server:
```sh
yarn
yarn parcel
```
