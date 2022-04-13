const ipfsClient = require('ipfs-http-client')

const projectId = '23gYWsmEFD4qN5JroLZ8uBK7vTr'
const projectSecret = 'e4ff63ae46506ebc75d714599524ab7a'
const auth =
  'Basic ' + Buffer.from(projectId + ':' + projectSecret).toString('base64')

const client = ipfsClient.create({
  host: 'ipfs.infura.io',
  port: 5001,
  protocol: 'https',
  headers: {
    authorization: auth
  }
})

client.pin.add('QmeGAVddnBSnKc1DLE7DLV9uuTqo5F7QbaveTjr45JUdQn').then((res) => {
  console.log(res)
})