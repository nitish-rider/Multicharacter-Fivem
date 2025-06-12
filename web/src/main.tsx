import ReactDOM from 'react-dom/client';
import App from './components/App';
import './index.css';
import '@mantine/core/styles.css';
import '@mantine/dates/styles.css';
import { MantineProvider } from '@mantine/core';
import { theme } from "./theme";
import './hooks/hooks';

ReactDOM.createRoot(document.getElementById('root')!).render(
  <MantineProvider theme={theme}>
    <App />
  </MantineProvider>
);
