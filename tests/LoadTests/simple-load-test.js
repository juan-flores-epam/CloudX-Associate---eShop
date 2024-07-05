import http from 'k6/http';

export const options = {
    stages: [
        { duration: '5m', target: 200 },
        { duration: '20m', target: 200 },
        { duration: '5m', target: 0 },
    ]
};

export default () => {
    http.get('https://app-web-cajz4gvl2hfwu.azurewebsites.net/')
}