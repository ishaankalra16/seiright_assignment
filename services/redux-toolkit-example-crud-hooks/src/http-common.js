import axios from "axios";

// Use environment variables for configuration
const baseURL = process.env.API_BASE_URL || "https://sei-backend.infra3.facetsdev.click/api";

export default axios.create({
  baseURL: baseURL,
  headers: {
    "Content-type": "application/json",
  },
});
