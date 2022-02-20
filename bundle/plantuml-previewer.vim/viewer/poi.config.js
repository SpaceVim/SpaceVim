module.exports = {
  plugins: [
    (poi) => {
      const isBuild = poi.command === 'build'
      if (isBuild) {
        poi.options.sourceMap = false
        poi.options.publicPath = './'
      }
    }
  ],
}
