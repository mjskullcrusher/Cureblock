import React from 'react';

const IdentityCard = ({ record }) => {
  if (!record) return null;

  const { on_chain_data, off_chain_data, blockchain_verified } = record;

  return (
    <div className="glass-panel animate-fade-in" style={{ padding: '2rem', marginTop: '2rem' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', borderBottom: '1px solid var(--border-light)', paddingBottom: '1rem', marginBottom: '1.5rem' }}>
        <h2 style={{ fontSize: '1.8rem', margin: 0 }}>Identity Profile</h2>
        {blockchain_verified && (
          <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem', background: 'rgba(16, 185, 129, 0.1)', padding: '0.5rem 1rem', borderRadius: '20px', border: '1px solid var(--success)' }}>
            <span className="status-indicator"></span>
            <span style={{ color: 'var(--success)', fontWeight: '600', fontSize: '0.9rem' }}>Blockchain Verified</span>
          </div>
        )}
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))', gap: '2rem' }}>
        
        {/* On-Chain Verification Section */}
        <div style={{ background: 'var(--bg-base)', padding: '1.5rem', borderRadius: '12px', border: '1px solid rgba(0,255,204,0.2)' }}>
          <h3 style={{ color: 'var(--primary)', marginBottom: '1rem', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
            <span style={{ fontSize: '1.2rem' }}>⛓️</span> On-Chain Anchors
          </h3>
          
          <div style={{ marginBottom: '1rem' }}>
            <label style={{ display: 'block', color: 'var(--text-muted)', fontSize: '0.8rem', textTransform: 'uppercase', letterSpacing: '1px' }}>Decentralized ID (DID)</label>
            <div style={{ fontFamily: 'monospace', color: 'var(--text-main)', background: 'rgba(255,255,255,0.05)', padding: '0.5rem', borderRadius: '6px', marginTop: '0.2rem', wordBreak: 'break-all' }}>
              {on_chain_data.did}
            </div>
          </div>

          <div style={{ marginBottom: '1rem' }}>
            <label style={{ display: 'block', color: 'var(--text-muted)', fontSize: '0.8rem', textTransform: 'uppercase', letterSpacing: '1px' }}>Fingerprint Hash (Keccak256)</label>
            <div style={{ fontFamily: 'monospace', color: 'var(--text-disabled)', background: 'rgba(255,255,255,0.02)', padding: '0.5rem', borderRadius: '6px', marginTop: '0.2rem', wordBreak: 'break-all', fontSize: '0.85rem' }}>
              {on_chain_data.fingerprintHash}
            </div>
          </div>

          <div style={{ marginBottom: '1rem' }}>
            <label style={{ display: 'block', color: 'var(--text-muted)', fontSize: '0.8rem', textTransform: 'uppercase', letterSpacing: '1px' }}>IPFS Content ID (CID)</label>
            <div style={{ fontFamily: 'monospace', color: 'var(--secondary)', background: 'rgba(123, 97, 255, 0.1)', padding: '0.5rem', borderRadius: '6px', marginTop: '0.2rem', wordBreak: 'break-all' }}>
              <a href={`https://gateway.pinata.cloud/ipfs/${on_chain_data.ipfsCID}`} target="_blank" rel="noopener noreferrer" style={{ color: 'inherit', textDecoration: 'none' }}>
                {on_chain_data.ipfsCID} ↗
              </a>
            </div>
          </div>
        </div>

        {/* Off-Chain Data Section */}
        <div style={{ background: 'var(--bg-base)', padding: '1.5rem', borderRadius: '12px', border: '1px solid var(--border-light)' }}>
          <h3 style={{ color: 'var(--text-main)', marginBottom: '1rem', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
            <span style={{ fontSize: '1.2rem' }}>📦</span> IPFS Payload (Decrypted)
          </h3>
          
          <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', borderBottom: '1px solid var(--border-light)', paddingBottom: '0.5rem' }}>
              <span style={{ color: 'var(--text-muted)' }}>Timestamp</span>
              <span style={{ color: 'var(--text-main)', fontWeight: '500' }}>{off_chain_data.timestamp}</span>
            </div>
            
            <div style={{ display: 'flex', justifyContent: 'space-between', borderBottom: '1px solid var(--border-light)', paddingBottom: '0.5rem' }}>
              <span style={{ color: 'var(--text-muted)' }}>Device ID</span>
              <span style={{ color: 'var(--text-main)', fontFamily: 'monospace' }}>{off_chain_data.device_id}</span>
            </div>

            <div style={{ marginTop: '0.5rem' }}>
              <label style={{ display: 'block', color: 'var(--text-muted)', fontSize: '0.8rem', marginBottom: '0.5rem' }}>Extracted Minutiae Template (Fingerprint)</label>
              <pre style={{ 
                background: '#000', 
                padding: '1rem', 
                borderRadius: '8px', 
                color: '#10b981', 
                fontSize: '0.75rem',
                overflowX: 'auto',
                border: '1px solid #10b98133'
              }}>
                {JSON.stringify(off_chain_data.fingerprint_template, null, 2)}
              </pre>
            </div>
          </div>
        </div>

      </div>
    </div>
  );
};

export default IdentityCard;
