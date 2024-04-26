const processTrue = (data) => {
    return {status: true,
        data: data,
        msg: 'Success'}
}

const processFalse = (data) => {
    return {status: false,
        data: data,
        msg: 'Failure'}
}
module.exports = { processTrue, processFalse };