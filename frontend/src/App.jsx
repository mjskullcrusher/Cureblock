import { useState } from 'react';
import IdentityCard from './components/IdentityCard';

function App() {
  const [did, setDid] = useState('');
  const [record, setRecord] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleSearch = async (e) => {
    e.preventDefault();
    if (!did.trim()) return;

    setLoading(true);
    setError('');
    setRecord(null);

    try {
      const response = await fetch(`http://127.0.0.1:8000/api/v1/record/${did}`);
      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.detail || 'Failed to fetch identity record');
      }

      setRecord(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const loadDemo = () => {
    setDid('did:cureblock:test-child-999');
  };

  return (
    <div style={{ minHeight: '80vh', display: 'flex', flexDirection: 'column' }}>
      
      {/* Header */}
      <header style={{ textAlign: 'center', marginBottom: '3rem', paddingTop: '2rem' }}>
        <h1 className="text-gradient" style={{ fontSize: '3.5rem', marginBottom: '0.5rem', letterSpacing: '-1px' }}>
          Cureblock Explorer
        </h1>
        <p style={{ color: 'var(--text-muted)', fontSize: '1.2rem', maxWidth: '600px', margin: '0 auto' }}>
          Securely retrieve and verify immutable pediatric biometric profiles from the Ethereum Blockchain and IPFS.
        </p>
      </header>

      {/* Search Bar */}
      <div className="glass-panel" style={{ padding: '2rem', maxWidth: '800px', margin: '0 auto', width: '100%' }}>
        <form onSubmit={handleSearch} style={{ display: 'flex', gap: '1rem', flexDirection: 'column' }}>
          
          <div style={{ display: 'flex', gap: '1rem' }}>
            <input
              type="text"
              className="search-input"
              placeholder="Enter Decentralized Identifier (e.g. did:cureblock:...)"
              value={did}
              onChange={(e) => setDid(e.target.value)}
              disabled={loading}
            />
            <button type="submit" className="btn-primary" disabled={loading || !did.trim()}>
              {loading ? 'Searching...' : 'Retrieve'}
            </button>
          </div>

          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginTop: '0.5rem' }}>
            <span style={{ fontSize: '0.85rem', color: 'var(--text-disabled)' }}>
              Connected to: <span style={{ color: 'var(--secondary)' }}>Sepolia Testnet</span>
            </span>
            <button 
              type="button" 
              onClick={loadDemo}
              style={{ background: 'transparent', border: 'none', color: 'var(--primary)', cursor: 'pointer', fontSize: '0.9rem', textDecoration: 'underline' }}
            >
              Load Demo DID
            </button>
          </div>

        </form>
      </div>

      {/* Error Message */}
      {error && (
        <div className="animate-fade-in" style={{ background: 'rgba(239, 68, 68, 0.1)', border: '1px solid var(--error)', color: 'var(--error)', padding: '1rem', borderRadius: '12px', maxWidth: '800px', margin: '2rem auto 0', width: '100%', textAlign: 'center' }}>
          ⚠️ {error}
        </div>
      )}

      {/* Results */}
      {record && (
        <div style={{ maxWidth: '1000px', margin: '0 auto', width: '100%' }}>
          <IdentityCard record={record} />
        </div>
      )}

    </div>
  );
}

export default App;
