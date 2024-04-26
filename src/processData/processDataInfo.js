const processDataInfo = (data) => {
    const status = !!data.length;
    const msg = status ? "Success" : "Failure";
    return {status: status,
        data: data,
        msg: msg}
}

const processDataInforowsAffected = (data) => {
    const status = data > 0;
    const msg = status ? "Success" : "Failure";
    return {status: status,
        data: data,
        msg: msg}
}
module.exports = processDataInfo, processDataInforowsAffected;